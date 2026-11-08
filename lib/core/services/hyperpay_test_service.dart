import 'dart:developer';

import 'package:dio/dio.dart';

/// ☹️ TEMPORARY TESTING SERVICE — سيتم حذفه قبل الـ Production
///
/// هذا خدمة مؤقتة لتوليد checkoutId من HyperPay Test Environment
/// مباشرة من التطبيق — للاختبار فقط وبدون backend
///
/// معلومات الاختبار من HyperPay Docs (علنية):
///   entityId: 8a8294174b7ecb28014b9699220015ca
///   token:    OGE4Mjk0MTc0YjdlY2IyODAxNGI5Njk5MjIwMDE1Y2Z8c3k2WTd3OWZxNw==
class HyperPayTestService {
  static const String _testBaseUrl = 'https://eu-test.oppwa.com/v1';
  static const String _entityId = '8a8294174b7ecb28014b9699220015ca';
  static const String _authToken =
      'Bearer OGE4Mjk0MTc0YjdlY2IyODAxNGI5Njk5MjIwMDE1Y2Z8c3k2WTd3OWZxNw==';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _testBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    contentType: 'application/x-www-form-urlencoded',
  ));

  /// توليد checkoutId من HyperPay Test API مباشرة من التطبيق
  /// [amount] مثل: 3500.00   [currency] مثل: SAR
  Future<String> createTestCheckout({
    required String amount,
    String currency = 'SAR',
  }) async {
    try {
      log('[HyperPayTestService] Creating test checkout: amount=$amount, currency=$currency');

      final response = await _dio.post(
        '/checkouts',
        data: {
          'entityId': _entityId,
          'amount': amount,
          'currency': currency,
          'paymentType': 'DB', // Direct Debit (purchase)
        },
        options: Options(headers: {'Authorization': _authToken}),
      );

      final checkoutId = response.data['id'] as String?;
      if (checkoutId == null || checkoutId.isEmpty) {
        throw Exception('HyperPay did not return checkoutId');
      }

      log('[HyperPayTestService] Created checkoutId=$checkoutId');
      return checkoutId;
    } on DioException catch (e) {
      log('[HyperPayTestService] DioError: ${e.response?.data ?? e.message}');
      throw Exception('Failed to create HyperPay checkout: ${e.message}');
    } catch (e) {
      log('[HyperPayTestService] Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
