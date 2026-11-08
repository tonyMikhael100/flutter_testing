import 'package:flutter_testing/features/chats/data/models/message_type.dart';

class MessageModel {
  const MessageModel({required this.text, required this.type});

  final String text;
  final MessageType type;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final textParts = <String>[];
    final content = json['content'];

    if (content is List) {
      for (final part in content.whereType<Map<String, dynamic>>()) {
        final text = part['text'];
        if (part['type'] == 'text' && text is String) textParts.add(text);
      }
    }

    return MessageModel(text: textParts.join(), type: MessageType.model);
  }

  Map<String, dynamic> toJson() => {
        'type': type.stepType,
        'content': [
          {'type': 'text', 'text': text},
        ],
      };

  static List<MessageModel> listFromJson(Map<String, dynamic> json) {
    final steps = json['steps'];
    if (steps is! List) return [];

    return steps
        .whereType<Map<String, dynamic>>()
        .where((step) => step['type'] == 'model_output')
        .map(MessageModel.fromJson)
        .where((message) => message.text.trim().isNotEmpty)
        .toList(growable: false);
  }
}
