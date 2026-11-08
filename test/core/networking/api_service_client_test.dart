import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/core/networking/api_endpoints.dart';
import 'package:flutter_testing/core/networking/api_keys.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';

const _hello = MessageModel(text: 'Hello', type: MessageType.user);
const _helloStep = {
  'type': 'user_input',
  'content': [
    {'type': 'text', 'text': 'Hello'},
  ],
};

void main() {
  test('posts authenticated JSON and reads the model reply', () async {
    final adapter = FakeGeminiAdapter(
      body: {
        'id': 'interaction-1',
        'status': 'completed',
        'steps': [
          {'type': 'thought', 'signature': 'not-a-reply'},
          {
            'type': 'model_output',
            'content': [
              {'type': 'text', 'text': 'Hello '},
              {'type': 'text', 'text': 'there!'},
            ],
          },
        ],
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;
    addTearDown(() => dio.close(force: true));
    final client = ApiServiceClient(dio);

    final response = await client.sendMessage(
      apiKey: 'test-key',
      request: const AiChatRequest(model: 'test-model', messages: [_hello]),
    );

    expect(adapter.request!.method, 'POST');
    expect(adapter.request!.uri.toString(), ApiEndpoints.gemini);
    expect(adapter.request!.headers['x-goog-api-key'], 'test-key');
    expect(adapter.request!.contentType, Headers.jsonContentType);
    expect(adapter.request!.data, {
      'model': 'test-model',
      'input': [_helloStep],
    });
    expect(response['id'], 'interaction-1');
    expect(response['status'], 'completed');

    await client.sendMessage(
      request: const AiChatRequest(
        model: 'test-model',
        messages: [
          _hello,
          MessageModel(text: 'Hi!', type: MessageType.model),
          MessageModel(text: 'Continue', type: MessageType.user),
        ],
      ),
    );
    expect(adapter.request!.data, {
      'model': 'test-model',
      'input': [
        _helloStep,
        {
          'type': 'model_output',
          'content': [
            {'type': 'text', 'text': 'Hi!'},
          ],
        },
        {
          'type': 'user_input',
          'content': [
            {'type': 'text', 'text': 'Continue'},
          ],
        },
      ],
    });
    expect(
        adapter.request!.headers['x-goog-api-key'] == ApiKeys.gemini, isTrue);
  });

  test('HTTP errors remain failures for the repository to handle', () async {
    final adapter = FakeGeminiAdapter(
      statusCode: 429,
      body: {
        'error': {'message': 'Quota exceeded'},
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;
    addTearDown(() => dio.close(force: true));

    await expectLater(
      ApiServiceClient(dio).sendMessage(
        apiKey: 'test-key',
        request: const AiChatRequest(model: 'test-model', messages: [_hello]),
      ),
      throwsA(
        isA<DioException>()
            .having((error) => error.type, 'type', DioExceptionType.badResponse)
            .having((error) => error.response?.statusCode, 'statusCode', 429),
      ),
    );
  });

  test('missing or malformed content does not become a model reply', () {
    expect(MessageModel.listFromJson({}), isEmpty);
    final messages = MessageModel.listFromJson({
      'steps': [
        null,
        {
          'type': 'user_input',
          'content': [
            {'type': 'text', 'text': 'Do not repeat my input'},
          ],
        },
        {'type': 'model_output', 'content': 'invalid'},
        {
          'type': 'model_output',
          'content': [
            null,
            {'type': 'image', 'text': 'not text'},
            {'type': 'text', 'text': 42},
            {'type': 'text', 'text': 'Valid reply'},
          ],
        },
      ],
    });

    expect(messages.single.text, 'Valid reply');
  });
}

class FakeGeminiAdapter implements HttpClientAdapter {
  FakeGeminiAdapter({required this.body, this.statusCode = 200});

  final Map<String, dynamic> body;
  final int statusCode;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
