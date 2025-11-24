import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import 'base_usecase.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });
}

class UpdateProfileParams {
  final String userId;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;

  const UpdateProfileParams({
    required this.userId,
    this.name,
    this.phoneNumber,
    this.profileImageUrl,
  });
}

abstract class LoginUseCase implements UseCase<User, LoginParams> {}

abstract class RegisterUseCase implements UseCase<User, RegisterParams> {}

abstract class LogoutUseCase implements UseCase<void, NoParams> {}

abstract class GetCurrentUserUseCase implements UseCase<User?, NoParams> {}

abstract class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {}

abstract class SendPasswordResetUseCase implements UseCase<void, String> {}

abstract class VerifyEmailUseCase implements UseCase<void, String> {}
