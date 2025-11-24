import '../../domain/entities/user.dart';

// API Response Base
class ApiResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}

// Authentication Responses
class LoginResponse {
  final User user;
  final TokenResponse tokens;

  const LoginResponse({
    required this.user,
    required this.tokens,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      tokens: TokenResponse.fromJson(json['tokens']),
    );
  }
}

class RegisterResponse {
  final User user;
  final TokenResponse tokens;
  final bool emailVerificationRequired;

  const RegisterResponse({
    required this.user,
    required this.tokens,
    required this.emailVerificationRequired,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: User.fromJson(json['user']),
      tokens: TokenResponse.fromJson(json['tokens']),
      emailVerificationRequired: json['email_verification_required'] ?? false,
    );
  }
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }

  String get authorizationHeader => '$tokenType $accessToken';
}

class SocialLoginResponse {
  final User user;
  final TokenResponse tokens;
  final bool isNewUser;

  const SocialLoginResponse({
    required this.user,
    required this.tokens,
    required this.isNewUser,
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    return SocialLoginResponse(
      user: User.fromJson(json['user']),
      tokens: TokenResponse.fromJson(json['tokens']),
      isNewUser: json['is_new_user'] ?? false,
    );
  }
}

// User Responses
class UserResponse {
  final User user;

  const UserResponse({required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(user: User.fromJson(json['user']));
  }
}

// User Entity Extension for JSON
extension UserJsonExtension on User {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],
      createdAt: DateTime.parse(json['created_at']),
      isEmailVerified: json['is_email_verified'] ?? false,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.customer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'role': role.name,
    };
  }
}
