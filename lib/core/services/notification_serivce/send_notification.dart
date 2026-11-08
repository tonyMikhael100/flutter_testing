// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:leaptech_plus/core/services/supabase_service.dart';

// /// ****************************************************************
// /// 🔵 LOAD SERVICE ACCOUNT JSON FILE
// /// ****************************************************************
// Future<Map<String, dynamic>> loadServiceAccount() async {
//   final jsonString =
//       await rootBundle.loadString('assets/service_account_key.json');
//   return jsonDecode(jsonString) as Map<String, dynamic>;
// }

// /// ****************************************************************
// /// 🔵 SEND FCM HTTP v1 NOTIFICATION TO SPECIFIC TOKEN
// /// ****************************************************************
// Future<void> sendFcmNotification({
//   required String fcmToken,
//   required String title,
//   required String body,
//   Map<String, String>? data,
//   String? employeeId, // Add employeeId parameter
// }) async {
//   try {
//     // Store notification in database first
//     if (employeeId != null) {
//       final supabaseService = SupabaseService();
//       await supabaseService.insertNotification(
//         employeeId: employeeId,
//         title: title,
//         body: body,
//       );
//     }

//     final serviceAccountJson = await loadServiceAccount();
//     final accountCredentials =
//         ServiceAccountCredentials.fromJson(serviceAccountJson);

//     const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

//     // Auth client
//     final client = await clientViaServiceAccount(accountCredentials, scopes);

//     const projectId = 'leaptechplus-c31b0';
//     final url = Uri.parse(
//       'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
//     );

//     final payload = {
//       "message": {
//         "token": fcmToken,
//         "notification": {"title": title, "body": body},
//         "data": data ?? {},
//         "android": {
//           "priority": "HIGH",
//           "notification": {"channel_id": "high_importance_channel"}
//         },
//         "apns": {
//           "headers": {"apns-priority": "10"},
//           "payload": {
//             "aps": {"sound": "default"}
//           }
//         }
//       }
//     };

//     final response = await client.post(
//       url,
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 200) {
//     } else {}

//     client.close();
//   } on Exception catch (e) {}
// }
