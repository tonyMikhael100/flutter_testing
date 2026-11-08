// import 'package:image_picker/image_picker.dart';

// /// Result wrapper so callers don't need to catch exceptions themselves.
// class PickImageResult {
//   final List<XFile> files;
//   final String? error;

//   const PickImageResult({required this.files, this.error});

//   bool get isSuccess => error == null;
//   bool get isEmpty => files.isEmpty;
//   XFile? get single => files.isNotEmpty ? files.first : null;
// }

// /// Service for all image-picking operations.
// /// Place in core/services/ — it wraps a device capability.
// ///
// /// Usage:
// /// ```dart
// /// final result = await PickImageService.pickOneImage();
// /// if (result.isSuccess && result.single != null) { … }
// /// ```
// class PickImageService {
//   PickImageService._();

//   static final ImagePicker _picker = ImagePicker();

//   // ── Single image — gallery ─────────────────────────────────────────────────

//   /// Opens the photo gallery and lets the user choose **one** image.
//   /// Returns [PickImageResult.error] if permission is denied or a
//   /// platform exception occurs. Returns empty files if user cancels.
//   static Future<PickImageResult> pickOneImage({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//   }) async {
//     try {
//       final XFile? file = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         // imageQuality: imageQuality ?? 85,
//       );
//       return PickImageResult(files: file != null ? [file] : []);
//     } on Exception catch (e) {
//       return PickImageResult(
//         files: [],
//         error: _mapError(e),
//       );
//     }
//   }

//   // ── Multiple images — gallery ──────────────────────────────────────────────

//   /// Opens the photo gallery and lets the user choose **multiple** images.
//   static Future<PickImageResult> pickMultipleImages({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//     int? limit,
//   }) async {
//     try {
//       final List<XFile> files = await _picker.pickMultiImage(
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         imageQuality: imageQuality ?? 85,
//         limit: limit,
//       );
//       return PickImageResult(files: files);
//     } on Exception catch (e) {
//       return PickImageResult(files: [], error: _mapError(e));
//     }
//   }

//   // ── Single image — camera ──────────────────────────────────────────────────

//   /// Opens the camera and lets the user capture **one** photo.
//   static Future<PickImageResult> pickFromCamera({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//     CameraDevice preferredCameraDevice = CameraDevice.rear,
//   }) async {
//     try {
//       final XFile? file = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         imageQuality: imageQuality ?? 85,
//         preferredCameraDevice: preferredCameraDevice,
//       );
//       return PickImageResult(files: file != null ? [file] : []);
//     } on Exception catch (e) {
//       return PickImageResult(files: [], error: _mapError(e));
//     }
//   }

//   // ── Video — gallery ────────────────────────────────────────────────────────

//   /// Opens the gallery and lets the user choose **one** video.
//   static Future<PickImageResult> pickOneVideo({
//     Duration? maxDuration,
//   }) async {
//     try {
//       final XFile? file = await _picker.pickVideo(
//         source: ImageSource.gallery,
//         maxDuration: maxDuration,
//       );
//       return PickImageResult(files: file != null ? [file] : []);
//     } on Exception catch (e) {
//       return PickImageResult(files: [], error: _mapError(e));
//     }
//   }

//   // ── Internal helpers ───────────────────────────────────────────────────────

//   static String _mapError(Exception e) {
//     final msg = e.toString().toLowerCase();
//     if (msg.contains('permission') || msg.contains('denied')) {
//       return 'لا يوجد إذن للوصول إلى الصور. يرجى السماح للتطبيق من الإعدادات.';
//     }
//     if (msg.contains('cancel') || msg.contains('cancelled')) {
//       return 'تم الإلغاء.';
//     }
//     if (msg.contains('unavailable') || msg.contains('no camera')) {
//       return 'الكاميرا غير متاحة على هذا الجهاز.';
//     }
//     return 'حدث خطأ غير متوقع أثناء اختيار الصورة.';
//   }
// }
