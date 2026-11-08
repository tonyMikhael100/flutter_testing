import 'package:easy_localization/easy_localization.dart';

String formatTime(String createdAt) {
  try {
    DateTime dt = DateTime.parse(createdAt);

    // API ترسل التوقيت بصيغة UTC ولكن أحياناً بدون Z أو ±
    // إذا لم يكن التوقيت UTC صريحاً، نعتبر أن API تقصد UTC ونحولها
    if (!dt.isUtc) {
      dt = DateTime.utc(
        dt.year,
        dt.month,
        dt.day,
        dt.hour,
        dt.minute,
        dt.second,
        dt.millisecond,
        dt.microsecond,
      );
    }

    // تحويل من UTC إلى توقيت الجهاز المحلي
    final localDt = dt.toLocal();
    final diff = DateTime.now().difference(localDt);

    if (diff.inMinutes < 1) return 'app.time.now'.tr();
    if (diff.inMinutes < 60) {
      return 'app.time.since_minutes'
          .tr(namedArgs: {'count': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return 'app.time.since_hours'.tr(namedArgs: {'count': '${diff.inHours}'});
    }
    if (diff.inDays < 7) {
      return 'app.time.since_days'.tr(namedArgs: {'count': '${diff.inDays}'});
    }
    return '${localDt.day}/${localDt.month}/${localDt.year}';
  } catch (_) {
    return createdAt;
  }
}
