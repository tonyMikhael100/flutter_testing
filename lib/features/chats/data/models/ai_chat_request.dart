class AiChatRequest {
  final String model;
  final String input;

  const AiChatRequest({
    required this.model,
    required this.input,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'input': input,
      };
}
