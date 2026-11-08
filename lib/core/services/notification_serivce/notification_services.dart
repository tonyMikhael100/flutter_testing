// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../../../firebase_options.dart';

// // ── القناة المشتركة ──────────────────────────────────────────────────────
// const _channelId = 'high_importance_channel';
// const _channelName = 'High Importance Notifications';
// const _channelDesc = 'Used for important notifications';

// /// ****************************************************************
// /// 🔵 TOP-LEVEL BACKGROUND HANDLER (must be top-level function)
// /// ****************************************************************
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

// /// ****************************************************************
// /// 🔵 NOTIFICATION SERVICE SINGLETON
// /// ****************************************************************
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _local =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   // ── FCM Token ────────────────────────────────────────────────────────────
//   /// On iOS, waits for the APNS token before requesting FCM token.
//   Future<String?> get fcmToken async {
//     if (Platform.isIOS) {
//       // Wait up to 10 seconds for APNS token
//       String? apnsToken = await _messaging.getAPNSToken();
//       int retries = 0;
//       while (apnsToken == null && retries < 3) {
//         await Future.delayed(const Duration(seconds: 1));
//         apnsToken = await _messaging.getAPNSToken();
//         retries++;
//       }
//       if (apnsToken == null) {
//         debugPrint('⚠️ APNS token not available after 3s');
//         return null;
//       }
//     }
//     return _messaging.getToken();
//   }

//   /// ****************************************************************
//   /// 🔵 INITIALIZATION (Call once in main.dart)
//   /// ****************************************************************
//   Future<void> init() async {
//     if (_isInitialized) return;
//     _isInitialized = true;

//     await _setupLocalNotifications();
//     await _requestPermissions();

//     // Foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         debugPrint('🔔 [FCM] Foreground message received!');
//         debugPrint('🔔 [FCM] notification: ${message.notification?.title}');
//         debugPrint('🔔 [FCM] data: ${message.data}');
//       }
//       _onForegroundMessage(message);
//     });

//     // Background
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // Notification tap (app in background)
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

//     // App opened from terminated state via notification
//     await _handleTerminatedMessage();

//     // Listen for token refresh
//     _messaging.onTokenRefresh.listen((newToken) {
//       if (kDebugMode) debugPrint('🔔 FCM Token refreshed: $newToken');
//     });

//     final token = await fcmToken;
//     if (kDebugMode) {
//       debugPrint('🔔 FCM Token: $token');
//     }
//     if (token == null) {
//       debugPrint(
//           '⚠️ FCM Token is NULL — emulator may not have Google Play Services!');
//     }
//   }

//   /// ****************************************************************
//   /// 🔵 LOCAL NOTIFICATIONS SETUP
//   /// ****************************************************************
//   Future<void> _setupLocalNotifications() async {
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     await _local.initialize(
//       settings: const InitializationSettings(
//         android: androidInit,
//         iOS: iosInit,
//       ),
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );

//     // Android notification channel
//     await _local
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(const AndroidNotificationChannel(
//           _channelId,
//           _channelName,
//           description: _channelDesc,
//           importance: Importance.high,
//         ));

//     // iOS foreground display
//     await _messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   /// ****************************************************************
//   /// 🔵 PERMISSIONS
//   /// ****************************************************************
//   Future<void> _requestPermissions() async {
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   /// ****************************************************************
//   /// 🔵 FOREGROUND MESSAGE → show local notification
//   /// ****************************************************************
//   Future<void> _onForegroundMessage(RemoteMessage message) async {
//     final notification = message.notification;
//     final data = message.data;

//     final title = notification?.title ?? data['title'];
//     final body = notification?.body ?? data['body'];
//     if (title == null && body == null) return;

//     await _showLocalNotification(
//       id: message.hashCode,
//       title: title,
//       body: body,
//     );
//   }

//   /// ****************************************************************
//   /// 🔵 NOTIFICATION TAP (background → foreground)
//   /// ****************************************************************
//   void _onMessageOpenedApp(RemoteMessage message) {
//     // TODO: navigate based on message.data
//   }

//   /// ****************************************************************
//   /// 🔵 APP OPENED FROM TERMINATED STATE
//   /// ****************************************************************
//   Future<void> _handleTerminatedMessage() async {
//     final message = await _messaging.getInitialMessage();
//     if (message != null) {
//       // TODO: navigate based on message.data
//     }
//   }

//   /// ****************************************************************
//   /// 🔵 LOCAL NOTIFICATION TAP CALLBACK
//   /// ****************************************************************
//   void _onNotificationTap(NotificationResponse response) {
//     // TODO: navigate based on response.payload
//   }

//   /// ****************************************************************
//   /// 🔵 SHOW LOCAL NOTIFICATION (helper)
//   /// ****************************************************************
//   Future<void> _showLocalNotification({
//     required int id,
//     String? title,
//     String? body,
//   }) async {
//     await _local.show(
//       id: id,
//       title: title,
//       body: body,
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           _channelName,
//           channelDescription: _channelDesc,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//     );
//   }
// }
