import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// نتيجة تسجيل الدخول عبر Apple — تحتوي على بيانات Firebase والتوكن
class AppleSignInResult {
  final UserCredential userCredential;
  final String identityToken;
  final String? email;
  final String? firstName;
  final String? lastName;

  const AppleSignInResult({
    required this.userCredential,
    required this.identityToken,
    this.email,
    this.firstName,
    this.lastName,
  });
}

/// خدمة تسجيل الدخول عبر Apple — مسؤولة فقط عن الاتصال بـ Apple و Firebase
/// بدون معالجة أخطاء — الأخطاء تُعالج في الـ Repository
class AppleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// تسجيل الدخول عبر Apple → Firebase ثم إرجاع النتيجة
  /// يرمي استثناءً في حالة الفشل
  Future<AppleSignInResult> signIn() async {
    // 1️⃣ طلب بيانات Apple
    final apple = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    log('[AppleSignIn] email=${apple.email}, name=${apple.givenName} ${apple.familyName}');

    // 2️⃣ التحقق من وجود التوكن
    final idToken = apple.identityToken;
    if (idToken == null) {
      throw Exception('لم يتم الحصول على توكن Apple');
    }

    // 3️⃣ تسجيل الدخول في Firebase
    final credential = OAuthProvider('apple.com').credential(
      idToken: idToken,
      accessToken: apple.authorizationCode,
    );
    final userCredential = await _auth.signInWithCredential(credential);

    return AppleSignInResult(
      userCredential: userCredential,
      identityToken: idToken,
      email: apple.email ?? userCredential.user?.email,
      firstName: apple.givenName,
      lastName: apple.familyName,
    );
  }
}
