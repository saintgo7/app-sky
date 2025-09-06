/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (code != null) {
      return '$runtimeType ($code): $message';
    }
    return '$runtimeType: $message';
  }
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Network-related exceptions  
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Cache and local storage exceptions
class CacheException extends AppException {
  const CacheException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Authorization exceptions
class AuthorizationException extends AppException {
  const AuthorizationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    super.message, {
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final errorStrings = fieldErrors!.entries
          .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
          .join('; ');
      return '$runtimeType: $message ($errorStrings)';
    }
    return super.toString();
  }
}

/// Business logic exceptions
class BookingException extends AppException {
  const BookingException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class PaymentException extends AppException {
  const PaymentException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class AvailabilityException extends AppException {
  const AvailabilityException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Data parsing exceptions
class DataParsingException extends AppException {
  const DataParsingException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// File and media exceptions
class FileException extends AppException {
  const FileException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// AI and ML exceptions
class AIException extends AppException {
  const AIException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Group operation exceptions
class GroupException extends AppException {
  const GroupException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// External service exceptions
class ExternalServiceException extends AppException {
  final String serviceName;

  const ExternalServiceException(
    super.message,
    this.serviceName, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    return '$runtimeType ($serviceName): $message';
  }
}

/// Timeout exceptions
class TimeoutException extends AppException {
  final Duration timeout;

  const TimeoutException(
    super.message,
    this.timeout, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    return '$runtimeType: $message (timeout: ${timeout.inMilliseconds}ms)';
  }
}

/// Rate limiting exceptions
class RateLimitException extends AppException {
  final Duration retryAfter;

  const RateLimitException(
    super.message,
    this.retryAfter, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    return '$runtimeType: $message (retry after: ${retryAfter.inSeconds}s)';
  }
}

/// Configuration exceptions
class ConfigurationException extends AppException {
  const ConfigurationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Generic unknown exception
class UnknownException extends AppException {
  const UnknownException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Helper functions for exception handling
class ExceptionHelper {
  /// Convert common errors to appropriate exceptions
  static AppException fromError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    if (error is FormatException) {
      return DataParsingException(
        'Invalid data format: ${error.message}',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is TypeError) {
      return DataParsingException(
        'Type conversion error: ${error.toString()}',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ArgumentError) {
      return ValidationException(
        'Invalid argument: ${error.toString()}',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return UnknownException(
      error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Check if exception is retriable
  static bool isRetriable(AppException exception) {
    return exception is NetworkException ||
           exception is TimeoutException ||
           (exception is ServerException && exception.code?.startsWith('5') == true);
  }

  /// Check if exception requires re-authentication
  static bool requiresReauth(AppException exception) {
    return exception is AuthenticationException ||
           (exception is ServerException && exception.code == '401');
  }

  /// Extract user-friendly message
  static String getUserMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return 'Please check your internet connection and try again.';
      case ServerException:
        return 'Server is temporarily unavailable. Please try again later.';
      case AuthenticationException:
        return 'Please log in again to continue.';
      case AuthorizationException:
        return 'You don\'t have permission to perform this action.';
      case ValidationException:
        return 'Please check your input and try again.';
      case BookingException:
        return 'Booking could not be completed. Please try again.';
      case PaymentException:
        return 'Payment processing failed. Please check your payment details.';
      case AvailabilityException:
        return 'Selected option is no longer available.';
      case RateLimitException:
        return 'Too many requests. Please wait a moment and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}