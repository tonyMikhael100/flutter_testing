class ApiKeys {
  ApiKeys._();

  /// Read at build time so the key never lives in source control.
  /// Run with: flutter run --dart-define-from-file=env.json
  static const String gemini = String.fromEnvironment('GEMINI_API_KEY');
}
