enum MessageType {
  user('user_input'),
  model('model_output');

  const MessageType(this.stepType);

  /// The step `type` Gemini's Interactions API uses for this sender.
  final String stepType;
}
