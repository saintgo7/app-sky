abstract class Failure {
  final String message;
  
  const Failure([this.message = '']);
  
  @override
  String toString() => message;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([super.message = 'Rate limit exceeded']);
}

// Authentication & Authorization Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed']);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'Access denied']);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure([super.message = 'Token has expired']);
}

// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure([super.message = 'Invalid input provided']);
}

// Data Failures
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'Resource conflict']);
}

class DataParsingFailure extends Failure {
  const DataParsingFailure([super.message = 'Failed to parse data']);
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache operation failed']);
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure([super.message = 'Local storage operation failed']);
}

// Business Logic Failures
class BookingFailure extends Failure {
  const BookingFailure([super.message = 'Booking operation failed']);
}

class PaymentFailure extends Failure {
  const PaymentFailure([super.message = 'Payment processing failed']);
}

class InsufficientFundsFailure extends Failure {
  const InsufficientFundsFailure([super.message = 'Insufficient funds']);
}

class AvailabilityFailure extends Failure {
  const AvailabilityFailure([super.message = 'No availability']);
}

// File and Media Failures
class FileUploadFailure extends Failure {
  const FileUploadFailure([super.message = 'File upload failed']);
}

class ImageProcessingFailure extends Failure {
  const ImageProcessingFailure([super.message = 'Image processing failed']);
}

// Permission Failures
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}

class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Location access failed']);
}

// AI and ML Failures
class AIProcessingFailure extends Failure {
  const AIProcessingFailure([super.message = 'AI processing failed']);
}

class RecommendationFailure extends Failure {
  const RecommendationFailure([super.message = 'Failed to generate recommendations']);
}

// Group and Social Failures
class GroupOperationFailure extends Failure {
  const GroupOperationFailure([super.message = 'Group operation failed']);
}

class InvitationFailure extends Failure {
  const InvitationFailure([super.message = 'Invitation operation failed']);
}

// External Service Failures
class ThirdPartyServiceFailure extends Failure {
  const ThirdPartyServiceFailure([super.message = 'Third-party service error']);
}

class GoogleServicesFailure extends Failure {
  const GoogleServicesFailure([super.message = 'Google services error']);
}

class FirebaseFailure extends Failure {
  const FirebaseFailure([super.message = 'Firebase operation failed']);
}

// Generic Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

// Extension methods for easier failure handling
extension FailureExtensions on Failure {
  bool get isNetworkFailure => this is NetworkFailure;
  bool get isServerFailure => this is ServerFailure;
  bool get isAuthFailure => this is AuthenticationFailure || this is AuthorizationFailure;
  bool get isValidationFailure => this is ValidationFailure || this is InvalidInputFailure;
  bool get isCacheFailure => this is CacheFailure || this is LocalStorageFailure;
  bool get isBusinessFailure => 
      this is BookingFailure || 
      this is PaymentFailure || 
      this is AvailabilityFailure ||
      this is InsufficientFundsFailure;
}

// Helper function to create appropriate failure from error codes
Failure createFailureFromStatusCode(int statusCode, [String? message]) {
  final errorMessage = message ?? 'Unknown error';
  
  switch (statusCode) {
    case 400:
      return ValidationFailure(errorMessage);
    case 401:
      return AuthenticationFailure(errorMessage);
    case 403:
      return AuthorizationFailure(errorMessage);
    case 404:
      return NotFoundFailure(errorMessage);
    case 409:
      return ConflictFailure(errorMessage);
    case 422:
      return ValidationFailure(errorMessage);
    case 429:
      return RateLimitFailure(errorMessage);
    case 500:
    case 502:
    case 503:
    case 504:
      return ServerFailure(errorMessage);
    default:
      return ServerFailure(errorMessage);
  }
}