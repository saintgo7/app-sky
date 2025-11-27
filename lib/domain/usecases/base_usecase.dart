import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class Failure {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'Failure: $message${code != null ? ' ($code)' : ''}';
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network connection failed'})
      : super(message: message, code: 'NETWORK_ERROR');
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred'})
      : super(message: message, code: 'SERVER_ERROR');
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache operation failed'})
      : super(message: message, code: 'CACHE_ERROR');
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message, Map<String, dynamic>? details})
      : super(message: message, code: 'VALIDATION_ERROR', details: details);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'Unauthorized access'})
      : super(message: message, code: 'UNAUTHORIZED');
}
