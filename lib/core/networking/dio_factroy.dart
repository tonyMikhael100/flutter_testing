import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_testing/core/routing/app_router.dart';
import 'package:flutter_testing/core/services/shared_pref_service.dart';
import 'package:flutter_testing/core/services/shared_preferences_service.dart';
import 'package:flutter_testing/core/utils/constants.dart';
import 'package:flutter_testing/core/utils/my_toast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFactory {
  //for singleton pattern to prevent more than one object from DioFactory class
  static final DioFactory _instance = DioFactory._internal();
  factory DioFactory() => _instance;
  DioFactory._internal();

  Dio? _dio;

  /// Initialize Dio instance (singleton)
  Future<Dio> getDio({required String baseUrl}) async {
    if (_dio != null) return _dio!;

    await SharedPreferencesService().init();
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('app_locale') ?? 'ar';

    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': savedLocale,
      },
    );

    final dio = Dio(baseOptions);
    // --------------------------------------------------
    // 🧩 Interceptors
    // --------------------------------------------------

    // 🔑 Add auth token interceptor — يضيف التوكن لكل طلب تلقائياً
    // 🚫 Handle 401 Unauthorized — يمسح الجلسة ويوجه المستخدم لتسجيل الدخول
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService().getData('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // حفظ الـ context قبل العمليات غير المتزامنة
            final ctx = AppRouter.navigatorKey.currentContext;

            // مسح بيانات الجلسة
            await SecureStorageService().remove(kToken);
            await SharedPreferencesService().setBool(kLoggedIn, false);

            // عرض تنبيه وتوجيه المستخدم لتسجيل الدخول
            if (ctx != null && ctx.mounted) {
              MyToast.warning(ctx, 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى');
              AppRouter.router.go(AppRouter.loginScreen);
            }
          }
          handler.next(error);
        },
      ),
    );

    // 🧾 Add pretty logging only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio = dio;
    return _dio!;
  }

  /// Update Accept-Language header when user changes locale
  Future<void> updateLanguage(String languageCode) async {
    if (_dio != null) {
      _dio!.options.headers['Accept-Language'] = languageCode;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', languageCode);
  }
}
