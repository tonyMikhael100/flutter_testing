import 'package:flutter_testing/features/chats/data/models/message_model.dart';

class AiChatRequest {
  static const String defaultModel = 'gemini-3.5-flash-lite';

  final String model;

  /// The conversation context sent to Gemini, oldest first.
  final List<MessageModel> messages;

  const AiChatRequest({
    this.model = defaultModel,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'input': messages.map((message) => message.toJson()).toList(),
      };
}
