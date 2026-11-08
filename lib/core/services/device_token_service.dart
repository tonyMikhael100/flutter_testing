// import 'dart:developer';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_testing/core/networking/api_service_client.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// /// خدمة تسجيل توكن FCM — تُستدعى بعد كل عملية تسجيل دخول ناجحة
// class DeviceTokenService {
//   final ApiServiceClient _apiServiceClient;

//   DeviceTokenService(this._apiServiceClient);

//   /// تسجيل توكن الجهاز مع الباك إند
//   /// يجمع: fcm_token, device_id, platform, os_version, app_version
//   Future<void> registerDeviceToken() async {
//     try {
//       // 1️⃣ الحصول على توكن FCM
//       final fcmToken = await FirebaseMessaging.instance.getToken();
//       if (fcmToken == null || fcmToken.isEmpty) {
//         log('[DeviceToken] FCM token is null — skipping registration');
//         return;
//       }

//       // 2️⃣ الحصول على معلومات الجهاز
//       final deviceInfo = DeviceInfoPlugin();
//       String deviceId = '';
//       String platform = '';

//       if (Platform.isAndroid) {
//         final android = await deviceInfo.androidInfo;
//         deviceId = android.id;
//         platform = 'android';
//       } else if (Platform.isIOS) {
//         final ios = await deviceInfo.iosInfo;
//         deviceId = ios.identifierForVendor ?? '';
//         platform = 'ios';
//       }

//       // 3️⃣ الحصول على إصدار التطبيق
//       final packageInfo = await PackageInfo.fromPlatform();
//       final appVersion = packageInfo.version;

//       // 4️⃣ إرسال البيانات إلى الباك إند
//       final body = {
//         'device_token': fcmToken,
//         'device_id': deviceId,
//         'device_os': platform.toUpperCase(), // ANDROID or IOS
//         'app_version': appVersion,
//       };

//       log('[DeviceToken] Registering: $body');
//       await _apiServiceClient.registerDeviceToken(body);
//       log('[DeviceToken] ✅ Token registered successfully');
//     } catch (e) {
//       // لا نوقف التطبيق بسبب فشل تسجيل التوكن
//       log('[DeviceToken] ❌ Failed to register token: $e');
//     }
//   }
// }
