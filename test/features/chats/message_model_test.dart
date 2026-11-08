import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';

void main() {
  test('extracts only the model message from the supplied response', () {
    final json = jsonDecode(
      File('test/fixtures/gemini_interaction.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final message = MessageModel.listFromJson(json).single;

    expect(message.type, MessageType.model);
    expect(
      message.text,
      "Hello! I'm doing well, functioning as expected. Thank you for asking! "
      'How are you doing today?',
    );
  });
}
