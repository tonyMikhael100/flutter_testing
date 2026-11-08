import 'dart:developer';
import 'dart:io';

import 'package:hyperpay_plugin/flutter_hyperpay.dart';
import 'package:hyperpay_plugin/model/ready_ui.dart';

// ─────────────────────────────────────────────────────────────────────────────
// نتيجة عملية الدفع — تُرجعها PaymentService للـ Cubit
// ─────────────────────────────────────────────────────────────────────────────

/// حالات ممكنة لنتيجة الدفع
enum HyperPayStatus {
  success, // ✅ دفع ناجح
  sync, // 🔄 قيد التحقق من الـ backend
  cancelled, // 🚫 ألغى المستخدم
  error, // ❌ حدث خطأ
}

/// كلاس يحمل نتيجة الدفع بعد إغلاق شاشة HyperPay
class HyperPayResult {
  final HyperPayStatus status;

  /// رسالة الخطأ — متاحة فقط عند status == error
  final String? errorMessage;

  const HyperPayResult._({
    required this.status,
    this.errorMessage,
  });

  factory HyperPayResult.success() => HyperPayResult._(
        status: HyperPayStatus.success,
      );

  factory HyperPayResult.sync() => HyperPayResult._(
        status: HyperPayStatus.sync,
      );

  factory HyperPayResult.cancelled() => HyperPayResult._(
        status: HyperPayStatus.cancelled,
      );

  factory HyperPayResult.error(String message) => HyperPayResult._(
        status: HyperPayStatus.error,
        errorMessage: message,
      );

  /// هل يجب التحقق من الـ backend؟ (نجاح أو sync)
  /// التحقق يتم بإرسال checkoutId الذي أرسله الـ Cubit أصلاً
  bool get requiresVerification =>
      status == HyperPayStatus.success || status == HyperPayStatus.sync;
}

// ─────────────────────────────────────────────────────────────────────────────
// PaymentService — خدمة الدفع عبر HyperPay
//
// المسؤوليات:
//   - تهيئة FlutterHyperPay بالإعدادات الصحيحة
//   - فتح شاشة الدفع الجاهزة (ReadyUI)
//   - ترجمة نتيجة SDK إلى HyperPayResult مفهوم
//
// الاستخدام من الـ Cubit:
//   final result = await PaymentService().pay(checkoutId: 'ABC123');
//   if (result.requiresVerification) {
//     await repo.verifyPayment(result.resourcePath!);
//   }
// ─────────────────────────────────────────────────────────────────────────────
class PaymentService {
  // ── إعدادات HyperPay ────────────────────────────────────────────────────────

  /// يجب أن يتطابق مع:
  ///   iOS  → CFBundleURLSchemes في ios/Runner/Info.plist
  ///   Android → android:scheme في AndroidManifest.xml
  /// مهم: في hyperpay_plugin على Android تتم مقارنة `intent.scheme` مع ShopperResultUrl،
  /// لذلك لازم نخزن "الـ scheme فقط" بدون `://...`.
  /// Example scheme: com.benaya.app.payments
  static const String _shopperResultUrlScheme = 'com.benaya.app.payments';

  /// Merchant ID الخاص بـ Apple Pay — يُسجَّل في Apple Developer Portal
  static const String _merchantIdApplePay = 'merchant.com.benaya.app';

  /// كود الدولة لـ Apple Pay
  static const String _countryCode = 'SA';

  /// اسم يظهر في شاشة Apple Pay
  static const String _companyName = 'Benaya';

  /// لون الثيم في شاشة iOS
  static const String _themeColor = '#1A73E8';

  /// وضع الدفع — غيّره إلى PaymentMode.live قبل الإطلاق
  static const PaymentMode _paymentMode = PaymentMode.test;

  // ── البطاقات/البراندز المدعومة ───────────────────────────────────────────────
  /// ملاحظة مهمة: `hyperpay_plugin` ReadyUI examples/docs use `MASTER`.
  /// APPLEPAY يعمل على iOS فقط.
  static List<String> get _defaultBrands => [
        'VISA',
        'MASTER',
        'MADA',
        if (Platform.isIOS) 'APPLEPAY',
      ];

  // ── اللغة ───────────────────────────────────────────────────────────────────
  /// iOS يقبل: 'ar' أو 'en'
  /// Android يقبل: 'ar_AR' أو 'en_US'
  static String get _lang => Platform.isIOS ? 'ar' : 'ar_AR';

  // ── الدالة الرئيسية ──────────────────────────────────────────────────────────

  /// تفتح شاشة الدفع وتنتظر حتى يُكمل المستخدم أو يلغي
  ///
  /// [checkoutId] : معرّف الدفعة المستلم من الـ backend
  Future<HyperPayResult> pay({
    required String checkoutId,
    List<String>? brands,
  }) async {
    log('[PaymentService] pay() called with checkoutId=$checkoutId');
    log('[PaymentService] shopperResultUrlScheme=$_shopperResultUrlScheme, mode=$_paymentMode, lang=$_lang');
    final resolvedBrands = (brands == null || brands.isEmpty)
        ? _defaultBrands
        : List<String>.from(brands);
    log('[PaymentService] brands=${resolvedBrands.join(", ")}');

    try {
      // 1️⃣ إنشاء instance من FlutterHyperPay
      final hyperPay = FlutterHyperPay(
        shopperResultUrl: _shopperResultUrlScheme,
        paymentMode: _paymentMode,
        lang: _lang,
      );

      // 2️⃣ فتح شاشة الدفع الجاهزة
      //    SDK يتولى: اختيار البطاقة، إدخال البيانات، 3DS، Apple Pay
      final sdkResult = await hyperPay.readyUICards(
        readyUI: ReadyUI(
          brandsName: resolvedBrands,
          checkoutId: checkoutId,
          merchantIdApplePayIOS: _merchantIdApplePay,
          countryCodeApplePayIOS: _countryCode,
          companyNameApplePayIOS: _companyName,
          themColorHexIOS: _themeColor,
          setStorePaymentDetailsMode: false, // حفظ البطاقة للمستقبل — معطّل
        ),
      );
      // 3️⃣ تحويل نتيجة SDK إلى HyperPayResult
      return _mapResult(sdkResult);
    } catch (e) {
      return HyperPayResult.error('app.tenant.paymentFlow.unexpectedError');
    }
  }

  // ── دالة مساعدة ──────────────────────────────────────────────────────────────

  /// تحوّل PaymentResultData من SDK إلى HyperPayResult
  HyperPayResult _mapResult(PaymentResultData sdkResult) {
    log('[PaymentService] SDK result: paymentResult=${sdkResult.paymentResult}, '
        'errorString=${sdkResult.errorString}');

    switch (sdkResult.paymentResult) {
      case PaymentResult.success:
        // ✅ دفع ناجح — الـ Cubit يستخدم checkoutId للتحقق من الـ backend
        return HyperPayResult.success();

      case PaymentResult.sync:
        // 🔄 الدفع قيد المعالجة — backend يتحقق منه باستخدام checkoutId
        return HyperPayResult.sync();

      case PaymentResult.error:
        // ❌ خطأ أثناء الدفع — errorString هو الحقل الصحيح في SDK
        // بعض الأجهزة/الـ SDK يرجّع "operation cancel" كـ error بدل cancelled
        final msg = (sdkResult.errorString ?? '').trim();
        final lower = msg.toLowerCase();
        if (lower.contains('operation cancel') || lower.contains('cancel')) {
          return HyperPayResult.cancelled();
        }
        return HyperPayResult.error(
          msg.isEmpty ? 'app.tenant.paymentFlow.paymentErrorGeneric' : msg,
        );
      default:
        // 🚫 ألغى المستخدم أو أغلق الشاشة
        return HyperPayResult.cancelled();
    }
  }
}
