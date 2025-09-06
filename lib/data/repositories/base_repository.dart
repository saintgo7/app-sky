import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local_data_source.dart';

// Either type for error handling
abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight);
  
  bool isLeft();
  bool isRight();
  
  L? getLeft();
  R? getRight();
  
  R getOrElse(R Function() orElse);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  
  const Left(this.value);
  
  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(value);
  
  @override
  bool isLeft() => true;
  
  @override
  bool isRight() => false;
  
  @override
  L? getLeft() => value;
  
  @override
  R? getRight() => null;
  
  @override
  R getOrElse(R Function() orElse) => orElse();
}

class Right<L, R> extends Either<L, R> {
  final R value;
  
  const Right(this.value);
  
  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(value);
  
  @override
  bool isLeft() => false;
  
  @override
  bool isRight() => true;
  
  @override
  L? getLeft() => null;
  
  @override
  R? getRight() => value;
  
  @override
  R getOrElse(R Function() orElse) => value;
}

abstract class BaseRepository {
  final NetworkInfo networkInfo;
  final LocalDataSource localDataSource;

  BaseRepository(this.networkInfo, this.localDataSource);

  Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() apiCall, {
    T? Function()? fallbackCache,
    Future<void> Function(T data)? cacheData,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await apiCall();
        
        // Cache the result if caching function provided
        if (cacheData != null) {
          try {
            await cacheData(result);
          } catch (e) {
            // Log cache error but don't fail the operation
            print('Cache error: $e');
          }
        }
        
        return Right(result);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // No internet connection, try to get cached data
      if (fallbackCache != null) {
        try {
          final cachedData = fallbackCache();
          if (cachedData != null) {
            return Right(cachedData);
          }
        } catch (e) {
          print('Cache retrieval error: $e');
        }
      }
      
      return Left(NetworkFailure());
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Connection timeout');
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';
        
        switch (statusCode) {
          case 400:
            return ValidationFailure(message);
          case 401:
            return AuthenticationFailure(message);
          case 403:
            return AuthorizationFailure(message);
          case 404:
            return NotFoundFailure(message);
          case 409:
            return ConflictFailure(message);
          case 422:
            return ValidationFailure(message);
          case 429:
            return RateLimitFailure(message);
          case 500:
          case 502:
          case 503:
          case 504:
            return ServerFailure(message);
          default:
            return ServerFailure(message);
        }
        
      case DioExceptionType.cancel:
        return NetworkFailure('Request cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkFailure('Connection error');
        
      case DioExceptionType.badCertificate:
        return NetworkFailure('Bad certificate');
        
      case DioExceptionType.unknown:
      default:
        return ServerFailure(error.message ?? 'Unknown error');
    }
  }

  Future<Either<Failure, List<T>>> handlePaginatedApiCall<T>(
    Future<PaginatedResponse<T>> Function() apiCall, {
    List<T> Function()? fallbackCache,
    Future<void> Function(List<T> data)? cacheData,
  }) async {
    final result = await handleApiCall<PaginatedResponse<T>>(
      apiCall,
      fallbackCache: fallbackCache != null 
        ? () => PaginatedResponse<T>(
            items: fallbackCache(),
            totalCount: fallbackCache().length,
            page: 1,
            totalPages: 1,
          )
        : null,
      cacheData: cacheData != null 
        ? (data) => cacheData(data.items)
        : null,
    );
    
    return result.fold(
      (failure) => Left(failure),
      (paginatedData) => Right(paginatedData.items),
    );
  }

  Future<Either<Failure, void>> handleVoidApiCall(
    Future<void> Function() apiCall,
  ) async {
    return await handleApiCall<void>(apiCall);
  }

  // Retry mechanism for failed requests
  Future<Either<Failure, T>> handleApiCallWithRetry<T>(
    Future<T> Function() apiCall, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    T? Function()? fallbackCache,
    Future<void> Function(T data)? cacheData,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      final result = await handleApiCall<T>(
        apiCall,
        fallbackCache: fallbackCache,
        cacheData: cacheData,
      );
      
      if (result.isRight() || attempt == maxRetries) {
        return result;
      }
      
      // Wait before retrying
      await Future.delayed(delay * (attempt + 1));
    }
    
    return Left(ServerFailure('Maximum retry attempts exceeded'));
  }

  // Batch operations
  Future<Either<Failure, List<T>>> handleBatchApiCall<T>(
    List<Future<T> Function()> apiCalls,
  ) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }

    try {
      final results = await Future.wait(
        apiCalls.map((call) => call()),
        eagerError: true,
      );
      return Right(results);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// Helper class for paginated responses
class PaginatedResponse<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int totalPages;
  
  const PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });
}