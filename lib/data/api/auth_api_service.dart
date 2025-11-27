import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_models.dart';
import 'base_api_client.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  static AuthApiService create() {
    return AuthApiService(BaseApiClient().dio);
  }

  // Authentication
  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/auth/refresh')
  Future<TokenResponse> refreshToken(@Body() RefreshTokenRequest request);

  @POST('/auth/logout')
  Future<ApiResponse> logout(@Header('Authorization') String token);

  // Password
  @POST('/auth/forgot-password')
  Future<ApiResponse> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST('/auth/reset-password')
  Future<ApiResponse> resetPassword(@Body() ResetPasswordRequest request);

  // Email Verification
  @POST('/auth/send-verification')
  Future<ApiResponse> sendEmailVerification(@Header('Authorization') String token);

  @POST('/auth/verify-email')
  Future<ApiResponse> verifyEmail(@Body() VerifyEmailRequest request);

  // Social Login
  @POST('/auth/google')
  Future<SocialLoginResponse> loginWithGoogle(@Body() SocialLoginRequest request);

  @POST('/auth/apple')
  Future<SocialLoginResponse> loginWithApple(@Body() SocialLoginRequest request);

  // Profile
  @GET('/auth/me')
  Future<UserResponse> getCurrentUser(@Header('Authorization') String token);

  @PUT('/auth/profile')
  Future<UserResponse> updateProfile(
    @Header('Authorization') String token,
    @Body() UpdateProfileRequest request,
  );

  @POST('/auth/profile/avatar')
  @MultiPart()
  Future<UserResponse> updateAvatar(
    @Header('Authorization') String token,
    @Part(name: 'avatar') MultipartFile file,
  );
}

// Request Models
class LoginRequest {
  final String email;
  final String password;
  final String? deviceToken;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'device_token': deviceToken,
  };
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String? deviceToken;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'phone_number': phoneNumber,
    'device_token': deviceToken,
  };
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String token;
  final String password;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.token,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'token': token,
    'password': password,
    'confirm_password': confirmPassword,
  };
}

class VerifyEmailRequest {
  final String token;

  VerifyEmailRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

class SocialLoginRequest {
  final String accessToken;
  final String? deviceToken;

  SocialLoginRequest({
    required this.accessToken,
    this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'device_token': deviceToken,
  };
}

class UpdateProfileRequest {
  final String? name;
  final String? phoneNumber;
  final String? avatarUrl;

  UpdateProfileRequest({
    this.name,
    this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (phoneNumber != null) 'phone_number': phoneNumber,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
  };
}
