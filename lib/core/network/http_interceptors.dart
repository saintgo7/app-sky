import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../environment/app_environment.dart';
import '../../data/datasources/local_data_source.dart';

/// Interceptor for automatic token attachment and refresh
class AuthInterceptor extends Interceptor {
  final LocalDataSource localDataSource;
  final Dio dio;
  bool _isRefreshing = false;

  AuthInterceptor(this.localDataSource, this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Skip token for auth endpoints
      final authEndpoints = ['/auth/login', '/auth/register', '/auth/refresh', '/auth/google', '/auth/facebook'];
      if (authEndpoints.any((endpoint) => options.path.contains(endpoint))) {
        handler.next(options);
        return;
      }

      final accessToken = await localDataSource.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - attempt token refresh
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await localDataSource.getRefreshToken();
        if (refreshToken != null) {
          final response = await _refreshToken(refreshToken);
          if (response != null) {
            // Save new tokens
            await localDataSource.saveAccessToken(response['access_token']);
            await localDataSource.saveRefreshToken(response['refresh_token']);

            // Retry original request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer ${response['access_token']}';
            
            final retryResponse = await dio.request(
              options.path,
              options: Options(
                method: options.method,
                headers: options.headers,
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );

            _isRefreshing = false;
            handler.resolve(retryResponse);
            return;
          }
        }

        // Refresh failed, clear tokens and redirect to login
        await localDataSource.clearAccessToken();
        await localDataSource.clearRefreshToken();
        await localDataSource.clearUserCache();
      } catch (e) {
        // Refresh failed
        await localDataSource.clearAccessToken();
        await localDataSource.clearRefreshToken();
        await localDataSource.clearUserCache();
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }

  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.data;
    } catch (e) {
      return null;
    }
  }
}

/// Interceptor for API request/response logging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode && AppEnvironment.isDebugMode) {
      print('🚀 REQUEST[${options.method}] ${options.uri}');
      print('Headers: ${options.headers}');
      if (options.data != null) {
        print('Body: ${_formatData(options.data)}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('Query Parameters: ${options.queryParameters}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode && AppEnvironment.isDebugMode) {
      print('✅ RESPONSE[${response.statusCode}] ${response.requestOptions.uri}');
      print('Response: ${_formatData(response.data)}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode && AppEnvironment.isDebugMode) {
      print('❌ ERROR[${err.response?.statusCode}] ${err.requestOptions.uri}');
      print('Error Type: ${err.type}');
      print('Error Message: ${err.message}');
      if (err.response?.data != null) {
        print('Error Response: ${_formatData(err.response!.data)}');
      }
    }
    handler.next(err);
  }

  String _formatData(dynamic data) {
    try {
      if (data is String) {
        return data;
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}

/// Interceptor for adding common headers and API versioning
class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Version': '1.0',
      'X-App-Version': '1.0.0', // Should come from app version
      'X-Platform': Platform.operatingSystem,
      'X-Environment': AppEnvironment.currentEnvironment.name,
    });

    // Add language header if available
    // This would typically come from app localization
    options.headers['Accept-Language'] = 'ko,en;q=0.9';

    handler.next(options);
  }
}

/// Interceptor for retry logic on network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      await _performRetry(err, handler);
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && 
            err.response!.statusCode! >= 500 && 
            err.response!.statusCode! < 600);
  }

  Future<void> _performRetry(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    int retryCount = requestOptions.extra['retryCount'] ?? 0;

    if (retryCount < maxRetries) {
      retryCount++;
      requestOptions.extra['retryCount'] = retryCount;

      // Wait before retrying
      await Future.delayed(retryDelay * retryCount);

      try {
        final response = await Dio().request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
            extra: requestOptions.extra,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
            validateStatus: requestOptions.validateStatus,
            receiveTimeout: requestOptions.receiveTimeout,
            sendTimeout: requestOptions.sendTimeout,
            followRedirects: requestOptions.followRedirects,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          cancelToken: requestOptions.cancelToken,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
        );

        handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          if (retryCount >= maxRetries) {
            handler.next(e);
          } else {
            await _performRetry(e, handler);
          }
        } else {
          handler.next(err);
        }
      }
    } else {
      handler.next(err);
    }
  }
}

/// Interceptor for request/response caching
class CacheInterceptor extends Interceptor {
  final Map<String, CacheItem> _cache = {};
  final Duration defaultCacheDuration;

  CacheInterceptor({
    this.defaultCacheDuration = const Duration(minutes: 5),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      handler.next(options);
      return;
    }

    // Check cache policy
    final cachePolicy = options.extra['cachePolicy'] as CachePolicy?;
    if (cachePolicy == CachePolicy.noCache) {
      handler.next(options);
      return;
    }

    // Check if we have cached response
    final cacheKey = _getCacheKey(options);
    final cachedItem = _cache[cacheKey];

    if (cachedItem != null && !cachedItem.isExpired()) {
      // Return cached response
      final response = Response(
        data: cachedItem.data,
        statusCode: 200,
        requestOptions: options,
        headers: Headers.fromMap({'x-cached': ['true']}),
      );
      
      if (kDebugMode) {
        print('📦 CACHE HIT: ${options.uri}');
      }
      
      handler.resolve(response);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    
    // Only cache successful GET responses
    if (options.method.toUpperCase() == 'GET' && 
        response.statusCode == 200 &&
        options.extra['cachePolicy'] != CachePolicy.noCache) {
      
      final cacheKey = _getCacheKey(options);
      final cacheDuration = options.extra['cacheDuration'] as Duration? ?? defaultCacheDuration;
      
      _cache[cacheKey] = CacheItem(
        data: response.data,
        timestamp: DateTime.now(),
        duration: cacheDuration,
      );

      if (kDebugMode) {
        print('💾 CACHED: ${options.uri}');
      }
    }

    handler.next(response);
  }

  String _getCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final headers = options.headers.toString();
    return '$uri-$headers'.hashCode.toString();
  }

  void clearCache() {
    _cache.clear();
  }

  void removeExpiredItems() {
    _cache.removeWhere((key, item) => item.isExpired());
  }
}

class CacheItem {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CacheItem({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool isExpired() {
    return DateTime.now().isAfter(timestamp.add(duration));
  }
}

enum CachePolicy {
  cacheFirst,
  networkFirst,
  cacheOnly,
  networkOnly,
  noCache,
}

/// Interceptor for rate limiting
class RateLimitInterceptor extends Interceptor {
  final Map<String, List<DateTime>> _requestTimestamps = {};
  final int maxRequestsPerMinute;

  RateLimitInterceptor({
    this.maxRequestsPerMinute = 60,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final now = DateTime.now();
    final key = _getRateLimitKey(options);
    
    _requestTimestamps[key] ??= [];
    final timestamps = _requestTimestamps[key]!;
    
    // Remove timestamps older than 1 minute
    timestamps.removeWhere((timestamp) => 
        now.difference(timestamp).inMinutes >= 1);
    
    // Check if we've exceeded the rate limit
    if (timestamps.length >= maxRequestsPerMinute) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          message: 'Rate limit exceeded. Too many requests.',
        ),
      );
      return;
    }
    
    // Add current timestamp
    timestamps.add(now);
    
    handler.next(options);
  }

  String _getRateLimitKey(RequestOptions options) {
    // Rate limit per endpoint
    return options.path;
  }
}

/// Interceptor for request/response compression
class CompressionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add compression headers
    options.headers['Accept-Encoding'] = 'gzip, deflate';
    
    // Compress request body if it's large enough
    if (options.data != null) {
      final dataString = options.data.toString();
      if (dataString.length > 1024) {
        options.headers['Content-Encoding'] = 'gzip';
        // Note: In a real implementation, you'd compress the data here
      }
    }
    
    handler.next(options);
  }
}

/// Factory class for creating configured Dio instances
class DioFactory {
  static Dio create({
    required LocalDataSource localDataSource,
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    final dio = Dio();
    
    // Base configuration
    dio.options = BaseOptions(
      baseUrl: baseUrl ?? AppEnvironment.baseApiUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    );

    // Add interceptors in order
    dio.interceptors.addAll([
      HeaderInterceptor(),
      AuthInterceptor(localDataSource, dio),
      CacheInterceptor(),
      RetryInterceptor(),
      RateLimitInterceptor(),
      CompressionInterceptor(),
      LoggingInterceptor(), // Should be last to log final request/response
    ]);

    return dio;
  }
}

/// Extension methods for easier cache policy usage
extension RequestOptionsExtension on RequestOptions {
  void setCachePolicy(CachePolicy policy, {Duration? duration}) {
    extra['cachePolicy'] = policy;
    if (duration != null) {
      extra['cacheDuration'] = duration;
    }
  }
  
  void setRetryConfig({int maxRetries = 3, Duration delay = const Duration(seconds: 1)}) {
    extra['maxRetries'] = maxRetries;
    extra['retryDelay'] = delay;
  }
}