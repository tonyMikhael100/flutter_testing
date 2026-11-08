import 'package:dio/dio.dart';

class Failure {
  final String errorMessage;
  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});

  /// Factory constructor to convert Dio exceptions into human-readable messages
  factory ServerFailure.dioErrorHandler(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errorMessage: 'Connection timeout, please try again later.',
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errorMessage: 'Request timeout, please try again later.',
        );

      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          errorMessage: 'Server took too long to respond, try again later.',
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          errorMessage: 'Request was cancelled, please try again.',
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          errorMessage: 'Bad SSL certificate, please check your network.',
        );

      case DioExceptionType.connectionError:
        return ServerFailure(
          errorMessage: 'No internet connection, please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _handleBadResponse(statusCode, error.response?.data);
        return ServerFailure(errorMessage: message);
      case DioExceptionType.unknown:
      default:
        return ServerFailure(
          errorMessage: 'Unexpected error occurred, please try again later.',
        );
    }
  }

  /// Helper to interpret API error responses based on status code or message
  static String _handleBadResponse(int? statusCode, dynamic data) {
    final error = data is Map ? data['error'] : null;
    final message = error is Map
        ? error['message']
        : data is Map
            ? data['message']
            : null;
    final serverMessage =
        message is String && message.trim().isNotEmpty ? message : null;

    switch (statusCode) {
      case 400:
        return 'Bad request, please check your input.';
      case 401:
        return 'Unauthorized, please login again.';
      case 403:
        return serverMessage ??
            'You do not have permission to make this request.';
      case 404:
        return 'Requested resource not found.';
      case 409:
        return 'Conflict occurred, please try again.';
      case 500:
        return 'Server error, please try again later.';
      case 503:
        return 'Server unavailable, please try again later.';
      default:
        return serverMessage ??
            'Something went wrong (${statusCode ?? 'unknown error'}).';
    }
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.errorMessage});
}

class SupabaseFailure extends Failure {
  SupabaseFailure({required super.errorMessage});

  factory SupabaseFailure.postgresErrorHandler(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('internet') ||
        message.contains('fetch failed')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.network',
      );
    }

    if (message.contains('timeout') || message.contains('timed out')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.timeout',
      );
    }

    if (message.contains('jwt') ||
        message.contains('auth') ||
        message.contains('session') ||
        message.contains('unauthorized')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.session_expired',
      );
    }

    if (message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('conflict')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.duplicate',
      );
    }

    if (message.contains('not found') || message.contains('404')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.not_found',
      );
    }

    if (message.contains('permission') ||
        message.contains('access denied') ||
        message.contains('403')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.permission',
      );
    }

    if (message.contains('foreign key') || message.contains('constraint')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.constraint',
      );
    }

    if (message.contains('null') || message.contains('nullability')) {
      return SupabaseFailure(
        errorMessage: 'errors.supabase.null_data',
      );
    }

    return SupabaseFailure(
      errorMessage: 'errors.supabase.generic',
    );
  }
}
