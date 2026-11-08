import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// نتيجة تسجيل الدخول عبر Google — تحتوي على بيانات Firebase
class GoogleSignInResult {
  final UserCredential userCredential;
  final String? email;
  final String? firstName;
  final String? lastName;

  const GoogleSignInResult({
    required this.userCredential,
    this.email,
    this.firstName,
    this.lastName,
  });
}

/// خدمة تسجيل الدخول عبر Google — مسؤولة فقط عن الاتصال بـ Google و Firebase
/// بدون معالجة أخطاء — الأخطاء تُعالج في الـ Repository
class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  /// تهيئة GoogleSignIn (تُستدعى مرة واحدة فقط)
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  /// تسجيل الدخول عبر Google → Firebase ثم إرجاع النتيجة
  /// يرمي استثناءً في حالة الفشل
  Future<GoogleSignInResult> signIn() async {
    await _ensureInitialized();

    // 1️⃣ تسجيل خروج أي حساب سابق لضمان حالة نظيفة
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    // 2️⃣ فتح نافذة تسجيل الدخول عبر Google
    final googleUser = await _googleSignIn.authenticate();

    log('[GoogleSignIn] email=${googleUser.email}, name=${googleUser.displayName}');

    // 3️⃣ الحصول على بيانات المصادقة
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception('لم يتم الحصول على توكن Google');
    }

    // 4️⃣ تسجيل الدخول في Firebase
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _auth.signInWithCredential(credential);

    // 5️⃣ تقسيم الاسم إلى أول وآخر
    final displayName = googleUser.displayName ?? '';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return GoogleSignInResult(
      userCredential: userCredential,
      email: googleUser.email,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
