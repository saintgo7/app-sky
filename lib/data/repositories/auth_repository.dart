import 'package:dio/dio.dart';

import '../api/auth_service.dart';
import '../models/user_model.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import 'base_repository.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);
  Future<Either<Failure, TokenResponse>> refreshToken(RefreshTokenRequest request);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequest request);
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);
  Future<Either<Failure, SocialLoginResponse>> googleLogin(GoogleLoginRequest request);
  Future<Either<Failure, CorporateLoginResponse>> corporateLogin(CorporateLoginRequest request);
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, UserModel>> updateProfile(UpdateProfileRequest request);
  Future<Either<Failure, void>> deleteAccount(DeleteAccountRequest request);
  Future<Either<Failure, List<UserSession>>> getActiveSessions();
  Future<Either<Failure, void>> terminateSession(String sessionId);
  
  // Local storage methods
  Future<Either<Failure, void>> saveTokens(String accessToken, String refreshToken);
  Future<Either<Failure, void>> clearTokens();
  Future<Either<Failure, String?>> getAccessToken();
  Future<Either<Failure, String?>> getRefreshToken();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, UserModel?>> getCachedUser();
  Future<Either<Failure, void>> cacheUser(UserModel user);
}

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService, super.networkInfo, super.localDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    return await handleApiCall(() async {
      final response = await _authService.login(request);
      await saveTokens(response.accessToken, response.refreshToken);
      await cacheUser(response.user);
      return response;
    });
  }

  @override
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request) async {
    return await handleApiCall(() async {
      return await _authService.register(request);
    });
  }

  @override
  Future<Either<Failure, TokenResponse>> refreshToken(RefreshTokenRequest request) async {
    return await handleApiCall(() async {
      final response = await _authService.refreshToken(request);
      await saveTokens(response.accessToken, response.refreshToken);
      return response;
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await getAccessToken();
      if (token.isRight()) {
        final accessToken = token.getOrElse(() => null);
        if (accessToken != null) {
          await _authService.logout('Bearer $accessToken');
        }
      }
      await clearTokens();
      await localDataSource.clearUserCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequest request) async {
    return await handleApiCall(() async {
      return await _authService.forgotPassword(request);
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) async {
    return await handleApiCall(() async {
      return await _authService.resetPassword(request);
    });
  }

  @override
  Future<Either<Failure, SocialLoginResponse>> googleLogin(GoogleLoginRequest request) async {
    return await handleApiCall(() async {
      final response = await _authService.googleLogin(request);
      await saveTokens(response.accessToken, response.refreshToken);
      await cacheUser(response.user);
      return response;
    });
  }

  @override
  Future<Either<Failure, CorporateLoginResponse>> corporateLogin(CorporateLoginRequest request) async {
    return await handleApiCall(() async {
      final response = await _authService.corporateLogin(request);
      await saveTokens(response.accessToken, response.refreshToken);
      await cacheUser(response.user);
      return response;
    });
  }

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    if (await networkInfo.isConnected) {
      return await handleApiCall(() async {
        final token = await getAccessToken();
        return token.fold(
          (failure) => throw ServerException('No access token available'),
          (accessToken) async {
            if (accessToken == null) {
              throw ServerException('No access token available');
            }
            final user = await _authService.getProfile('Bearer $accessToken');
            await cacheUser(user);
            return user;
          },
        );
      });
    } else {
      return await getCachedUser().then((result) {
        return result.fold(
          (failure) => Left(failure),
          (user) => user != null ? Right(user) : Left(CacheFailure()),
        );
      });
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(UpdateProfileRequest request) async {
    return await handleApiCall(() async {
      final token = await getAccessToken();
      return token.fold(
        (failure) => throw ServerException('No access token available'),
        (accessToken) async {
          if (accessToken == null) {
            throw ServerException('No access token available');
          }
          final user = await _authService.updateProfile('Bearer $accessToken', request);
          await cacheUser(user);
          return user;
        },
      );
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount(DeleteAccountRequest request) async {
    return await handleApiCall(() async {
      final token = await getAccessToken();
      return token.fold(
        (failure) => throw ServerException('No access token available'),
        (accessToken) async {
          if (accessToken == null) {
            throw ServerException('No access token available');
          }
          await _authService.deleteAccount('Bearer $accessToken', request);
          await clearTokens();
          await localDataSource.clearUserCache();
          return null;
        },
      );
    });
  }

  @override
  Future<Either<Failure, List<UserSession>>> getActiveSessions() async {
    return await handleApiCall(() async {
      final token = await getAccessToken();
      return token.fold(
        (failure) => throw ServerException('No access token available'),
        (accessToken) async {
          if (accessToken == null) {
            throw ServerException('No access token available');
          }
          return await _authService.getActiveSessions('Bearer $accessToken');
        },
      );
    });
  }

  @override
  Future<Either<Failure, void>> terminateSession(String sessionId) async {
    return await handleApiCall(() async {
      final token = await getAccessToken();
      return token.fold(
        (failure) => throw ServerException('No access token available'),
        (accessToken) async {
          if (accessToken == null) {
            throw ServerException('No access token available');
          }
          return await _authService.terminateSession('Bearer $accessToken', sessionId);
        },
      );
    });
  }

  // Local storage methods
  @override
  Future<Either<Failure, void>> saveTokens(String accessToken, String refreshToken) async {
    try {
      await localDataSource.saveAccessToken(accessToken);
      await localDataSource.saveRefreshToken(refreshToken);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearTokens() async {
    try {
      await localDataSource.clearAccessToken();
      await localDataSource.clearRefreshToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final token = await localDataSource.getAccessToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getRefreshToken() async {
    try {
      final token = await localDataSource.getRefreshToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await localDataSource.getAccessToken();
      return Right(token != null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cacheUser(UserModel user) async {
    try {
      await localDataSource.cacheUser(user);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}