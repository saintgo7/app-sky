import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/user_model.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String? baseUrl}) = _AuthService;

  // JWT Authentication
  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/auth/refresh')
  Future<TokenResponse> refreshToken(@Body() RefreshTokenRequest request);

  @POST('/auth/logout')
  Future<void> logout(@Header('Authorization') String token);

  @POST('/auth/forgot-password')
  Future<void> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST('/auth/reset-password')
  Future<void> resetPassword(@Body() ResetPasswordRequest request);

  @POST('/auth/verify-email')
  Future<void> verifyEmail(@Body() EmailVerificationRequest request);

  // Social Login
  @POST('/auth/google')
  Future<SocialLoginResponse> googleLogin(@Body() GoogleLoginRequest request);

  @POST('/auth/facebook')
  Future<SocialLoginResponse> facebookLogin(@Body() FacebookLoginRequest request);

  @POST('/auth/apple')
  Future<SocialLoginResponse> appleLogin(@Body() AppleLoginRequest request);

  // Corporate Authentication
  @POST('/auth/corporate/login')
  Future<CorporateLoginResponse> corporateLogin(@Body() CorporateLoginRequest request);

  @POST('/auth/corporate/register')
  Future<CorporateRegisterResponse> corporateRegister(@Body() CorporateRegisterRequest request);

  @POST('/auth/corporate/verify')
  Future<CorporateVerificationResponse> verifyCorporateCredentials(@Body() CorporateVerificationRequest request);

  // User Profile
  @GET('/auth/profile')
  Future<UserModel> getProfile(@Header('Authorization') String token);

  @PUT('/auth/profile')
  Future<UserModel> updateProfile(@Header('Authorization') String token, @Body() UpdateProfileRequest request);

  @DELETE('/auth/profile')
  Future<void> deleteAccount(@Header('Authorization') String token, @Body() DeleteAccountRequest request);

  // Session Management
  @GET('/auth/sessions')
  Future<List<UserSession>> getActiveSessions(@Header('Authorization') String token);

  @DELETE('/auth/sessions/{sessionId}')
  Future<void> terminateSession(@Header('Authorization') String token, @Path('sessionId') String sessionId);

  @DELETE('/auth/sessions/all')
  Future<void> terminateAllSessions(@Header('Authorization') String token);
}

// Request/Response Models
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
  final String? deviceId;
  final String? deviceName;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.deviceId,
    this.deviceName,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;
  final List<String> permissions;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final UserType userType;
  final String? companyName;
  final String? businessNumber;
  final bool acceptTerms;
  final bool acceptPrivacy;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.userType = UserType.individual,
    this.companyName,
    this.businessNumber,
    required this.acceptTerms,
    required this.acceptPrivacy,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final UserModel user;
  final String message;
  final bool requiresEmailVerification;

  const RegisterResponse({
    required this.user,
    required this.message,
    required this.requiresEmailVerification,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class EmailVerificationRequest {
  final String token;

  const EmailVerificationRequest({required this.token});

  factory EmailVerificationRequest.fromJson(Map<String, dynamic> json) => _$EmailVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EmailVerificationRequestToJson(this);
}

@JsonSerializable()
class GoogleLoginRequest {
  final String idToken;
  final String? accessToken;

  const GoogleLoginRequest({
    required this.idToken,
    this.accessToken,
  });

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) => _$GoogleLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleLoginRequestToJson(this);
}

@JsonSerializable()
class FacebookLoginRequest {
  final String accessToken;

  const FacebookLoginRequest({required this.accessToken});

  factory FacebookLoginRequest.fromJson(Map<String, dynamic> json) => _$FacebookLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FacebookLoginRequestToJson(this);
}

@JsonSerializable()
class AppleLoginRequest {
  final String identityToken;
  final String? authorizationCode;

  const AppleLoginRequest({
    required this.identityToken,
    this.authorizationCode,
  });

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) => _$AppleLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppleLoginRequestToJson(this);
}

@JsonSerializable()
class SocialLoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;
  final bool isNewUser;

  const SocialLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
    required this.isNewUser,
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) => _$SocialLoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SocialLoginResponseToJson(this);
}

@JsonSerializable()
class CorporateLoginRequest {
  final String email;
  final String password;
  final String companyCode;
  final String? department;

  const CorporateLoginRequest({
    required this.email,
    required this.password,
    required this.companyCode,
    this.department,
  });

  factory CorporateLoginRequest.fromJson(Map<String, dynamic> json) => _$CorporateLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateLoginRequestToJson(this);
}

@JsonSerializable()
class CorporateLoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;
  final List<String> companyPermissions;
  final String companyName;

  const CorporateLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
    required this.companyPermissions,
    required this.companyName,
  });

  factory CorporateLoginResponse.fromJson(Map<String, dynamic> json) => _$CorporateLoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateLoginResponseToJson(this);
}

@JsonSerializable()
class CorporateRegisterRequest {
  final String companyName;
  final String businessNumber;
  final String adminEmail;
  final String adminName;
  final String adminPassword;
  final String companyAddress;
  final String? companyPhone;
  final String? website;

  const CorporateRegisterRequest({
    required this.companyName,
    required this.businessNumber,
    required this.adminEmail,
    required this.adminName,
    required this.adminPassword,
    required this.companyAddress,
    this.companyPhone,
    this.website,
  });

  factory CorporateRegisterRequest.fromJson(Map<String, dynamic> json) => _$CorporateRegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateRegisterRequestToJson(this);
}

@JsonSerializable()
class CorporateRegisterResponse {
  final String companyId;
  final String companyCode;
  final UserModel adminUser;
  final String message;
  final bool requiresVerification;

  const CorporateRegisterResponse({
    required this.companyId,
    required this.companyCode,
    required this.adminUser,
    required this.message,
    required this.requiresVerification,
  });

  factory CorporateRegisterResponse.fromJson(Map<String, dynamic> json) => _$CorporateRegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateRegisterResponseToJson(this);
}

@JsonSerializable()
class CorporateVerificationRequest {
  final String businessNumber;
  final String companyName;

  const CorporateVerificationRequest({
    required this.businessNumber,
    required this.companyName,
  });

  factory CorporateVerificationRequest.fromJson(Map<String, dynamic> json) => _$CorporateVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateVerificationRequestToJson(this);
}

@JsonSerializable()
class CorporateVerificationResponse {
  final bool isValid;
  final String companyName;
  final String status;
  final Map<String, dynamic>? additionalInfo;

  const CorporateVerificationResponse({
    required this.isValid,
    required this.companyName,
    required this.status,
    this.additionalInfo,
  });

  factory CorporateVerificationResponse.fromJson(Map<String, dynamic> json) => _$CorporateVerificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CorporateVerificationResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? profileImage;
  final UserPreferences? preferences;
  final String? companyName;
  final String? department;
  final String? position;

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.profileImage,
    this.preferences,
    this.companyName,
    this.department,
    this.position,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

@JsonSerializable()
class DeleteAccountRequest {
  final String password;
  final String reason;

  const DeleteAccountRequest({
    required this.password,
    required this.reason,
  });

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) => _$DeleteAccountRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);
}

@JsonSerializable()
class UserSession {
  final String sessionId;
  final String deviceName;
  final String deviceType;
  final String? location;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final bool isCurrent;

  const UserSession({
    required this.sessionId,
    required this.deviceName,
    required this.deviceType,
    this.location,
    required this.createdAt,
    required this.lastActiveAt,
    required this.isCurrent,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);
  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}