import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/core/errors/failure.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';

void main() {
  const request = AiChatRequest(
    model: 'test-model',
    messages: [MessageModel(text: 'Hello', type: MessageType.user)],
  );

  test('returns separate messages and joins text parts within each output',
      () async {
    final client = FakeChatClient(response: {
      'steps': [
        {'type': 'thought', 'content': []},
        {
          'type': 'model_output',
          'content': [
            {'type': 'text', 'text': 'First '},
            {'type': 'text', 'text': 'reply'},
          ],
        },
        {
          'type': 'user_input',
          'content': [
            {'type': 'text', 'text': 'Do not include this'},
          ],
        },
        {
          'type': 'model_output',
          'content': [
            {'type': 'text', 'text': 'Second reply'},
          ],
        },
      ],
    });

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    expect(client.lastRequest, same(request));
    result.fold(
      (failure) => fail(failure.errorMessage),
      (messages) {
        expect(messages.map((message) => message.text),
            ['First reply', 'Second reply']);
        expect(messages.every((message) => message.type == MessageType.model),
            isTrue);
      },
    );
  });

  test('returns an empty list when the response has no text messages',
      () async {
    final client = FakeChatClient(response: {
      'steps': [
        null,
        {'type': 'thought'},
        {
          'type': 'model_output',
          'content': [
            {'type': 'text', 'text': '   '},
            {'type': 'image'},
          ],
        },
      ],
    });

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    result.fold((failure) => fail(failure.errorMessage),
        (messages) => expect(messages, isEmpty));
  });

  test('returns a failure for a timeout', () async {
    final client = FakeChatClient(
        error: DioException(
      requestOptions: RequestOptions(path: '/interactions'),
      type: DioExceptionType.connectionTimeout,
    ));

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('A timeout must not return messages'),
    );
  });

  test('preserves the error message in a Gemini HTTP error response', () async {
    final client = FakeChatClient(
        error: httpError(429, {
      'error': {'message': 'Quota exceeded'},
    }));

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    result.fold(
      (failure) => expect(failure.errorMessage, 'Quota exceeded'),
      (_) => fail('An HTTP error must not return messages'),
    );
  });

  test('non-JSON forbidden responses still return a failure', () async {
    final client = FakeChatClient(error: httpError(403, 'Forbidden'));

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    result.fold(
      (failure) => expect(failure.errorMessage, isNotEmpty),
      (_) => fail('A forbidden response must not return messages'),
    );
  });

  test('unexpected exceptions return a failure instead of escaping', () async {
    final client = FakeChatClient(error: StateError('Unexpected test error'));

    final result = await ChatRepoImp(apiServiceClient: client).send(request);

    result.fold(
      (failure) => expect(failure.errorMessage,
          'Unexpected error occurred, please try again later.'),
      (_) => fail('An exception must not return messages'),
    );
  });
}

DioException httpError(int statusCode, Object body) {
  final options = RequestOptions(path: '/interactions');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: body,
    ),
  );
}

class FakeChatClient implements ApiServiceClient {
  FakeChatClient({this.response = const {}, this.error});

  final Map<String, dynamic> response;
  final Object? error;
  AiChatRequest? lastRequest;

  @override
  Future<Map<String, Object?>> sendMessage({
    String apiKey = '',
    required AiChatRequest request,
  }) async {
    lastRequest = request;
    final requestError = error;
    if (requestError != null) throw requestError;
    return response;
  }
}
