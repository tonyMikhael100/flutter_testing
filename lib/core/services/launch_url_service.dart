import 'package:url_launcher/url_launcher.dart';

class LaunchUrlResult {
  final bool launched;
  final String? error;

  const LaunchUrlResult({required this.launched, this.error});

  bool get isSuccess => launched && error == null;
}

/// A small wrapper around `url_launcher` so callers don't need to deal with
/// parsing/validation and exceptions.
class LaunchUrlService {
  LaunchUrlService._();

  static Future<LaunchUrlResult> launch(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final Uri? uri = _parseUrl(url);
    if (uri == null) {
      return const LaunchUrlResult(
        launched: false,
        error: 'الرابط غير صالح.',
      );
    }

    try {
      final bool canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        return const LaunchUrlResult(
          launched: false,
          error: 'لا يمكن فتح الرابط على هذا الجهاز.',
        );
      }

      final bool launched = await launchUrl(uri, mode: mode);
      if (!launched) {
        return const LaunchUrlResult(
          launched: false,
          error: 'تعذر فتح الرابط.',
        );
      }

      return const LaunchUrlResult(launched: true);
    } on Exception {
      return const LaunchUrlResult(
        launched: false,
        error: 'حدث خطأ أثناء محاولة فتح الرابط.',
      );
    }
  }

  static Uri? _parseUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;

    final Uri? direct = Uri.tryParse(trimmed);
    if (direct == null) return null;

    if (direct.scheme.isNotEmpty) return direct;

    // If the scheme is missing (e.g. "www.example.com"), assume https.
    return Uri.tryParse('https://$trimmed');
  }
}

