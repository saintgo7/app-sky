import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/auth_api_service.dart';
import '../../data/api/search_api_service.dart';
import '../../data/api/booking_api_service.dart';
import '../../data/api/ai_api_service.dart';

// API Service Providers
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService.create();
});

final searchApiServiceProvider = Provider<SearchApiService>((ref) {
  return SearchApiService.create();
});

final bookingApiServiceProvider = Provider<BookingApiService>((ref) {
  return BookingApiService.create();
});

final aiApiServiceProvider = Provider<AiApiService>((ref) {
  return AiApiService.create();
});

// API 상태 관리 Providers
class ApiState<T> {
  final T? data;
  final bool isLoading;
  final String? error;

  const ApiState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  ApiState<T> copyWith({
    T? data,
    bool? isLoading,
    String? error,
  }) {
    return ApiState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasData => data != null;
  bool get hasError => error != null;
  bool get isInitial => !isLoading && !hasData && !hasError;
  bool get isSuccess => !isLoading && hasData && !hasError;
  bool get isFailure => !isLoading && hasError;
}

// 인증 API 상태 관리
class AuthApiNotifier extends StateNotifier<ApiState<void>> {
  final AuthApiService _authApiService;

  AuthApiNotifier(this._authApiService) : super(const ApiState());

  Future<bool> login(String email, String password) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _authApiService.login(
        LoginRequest(email: email, password: password),
      );

      state = const ApiState(isLoading: false);
      return true;
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _authApiService.register(
        RegisterRequest(
          email: email,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
        ),
      );

      state = const ApiState(isLoading: false);
      return true;
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authApiNotifierProvider = StateNotifierProvider<AuthApiNotifier, ApiState<void>>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  return AuthApiNotifier(authApiService);
});

// 검색 API 상태 관리
class SearchApiNotifier extends StateNotifier<ApiState<List<dynamic>>> {
  final SearchApiService _searchApiService;

  SearchApiNotifier(this._searchApiService) : super(const ApiState());

  Future<void> searchDestinations(String query) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _searchApiService.searchDestinations(query: query);

      state = ApiState(
        isLoading: false,
        data: response.destinations,
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchFlights({
    required String departureCity,
    required String arrivalCity,
    required DateTime departureDate,
  }) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _searchApiService.searchFlights(
        departureCity: departureCity,
        arrivalCity: arrivalCity,
        departureDate: departureDate.toIso8601String().split('T')[0],
      );

      state = ApiState(
        isLoading: false,
        data: response.flights,
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchHotels({
    required String city,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _searchApiService.searchHotels(
        city: city,
        checkIn: checkIn.toIso8601String().split('T')[0],
        checkOut: checkOut.toIso8601String().split('T')[0],
      );

      state = ApiState(
        isLoading: false,
        data: response.hotels,
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final searchApiNotifierProvider = StateNotifierProvider<SearchApiNotifier, ApiState<List<dynamic>>>((ref) {
  final searchApiService = ref.watch(searchApiServiceProvider);
  return SearchApiNotifier(searchApiService);
});

// 예약 API 상태 관리
class BookingApiNotifier extends StateNotifier<ApiState<List<dynamic>>> {
  final BookingApiService _bookingApiService;

  BookingApiNotifier(this._bookingApiService) : super(const ApiState());

  Future<void> loadBookings(String userId, {String? status}) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _bookingApiService.getBookings(
        token: 'bearer_token', // 실제 토큰 사용
        status: status,
      );

      state = ApiState(
        isLoading: false,
        data: response.bookings,
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    state = state.copyWith(isLoading: true);

    try {
      // 실제 API 호출로 교체 필요
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final bookingApiNotifierProvider = StateNotifierProvider<BookingApiNotifier, ApiState<List<dynamic>>>((ref) {
  final bookingApiService = ref.watch(bookingApiServiceProvider);
  return BookingApiNotifier(bookingApiService);
});

// AI API 상태 관리
class AiApiNotifier extends StateNotifier<ApiState<String>> {
  final AiApiService _aiApiService;

  AiApiNotifier(this._aiApiService) : super(const ApiState());

  Future<void> sendMessage(String message) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _aiApiService.sendMessage(
        token: 'bearer_token', // 실제 토큰 사용
        request: ChatRequest(message: message),
      );

      state = ApiState(
        isLoading: false,
        data: response.response,
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  Future<void> getRecommendations(String query) async {
    state = const ApiState(isLoading: true);

    try {
      final response = await _aiApiService.getRecommendations(
        token: 'bearer_token',
        request: RecommendationRequest(query: query),
      );

      state = ApiState(
        isLoading: false,
        data: response.recommendations.join(', '),
      );
    } catch (e) {
      state = ApiState(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final aiApiNotifierProvider = StateNotifierProvider<AiApiNotifier, ApiState<String>>((ref) {
  final aiApiService = ref.watch(aiApiServiceProvider);
  return AiApiNotifier(aiApiService);
});

// 네트워크 연결 상태 Provider
final connectivityProvider = StateProvider<bool>((ref) => true);

// API 에러 처리 헬퍼
class ApiErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;

    // DioException 처리
    if (error.toString().contains('NetworkException')) {
      return '네트워크 연결을 확인해주세요.';
    }

    if (error.toString().contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
    }

    if (error.toString().contains('401')) {
      return '인증이 만료되었습니다. 다시 로그인해주세요.';
    }

    if (error.toString().contains('403')) {
      return '접근 권한이 없습니다.';
    }

    if (error.toString().contains('404')) {
      return '요청한 정보를 찾을 수 없습니다.';
    }

    if (error.toString().contains('500')) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }

    return '알 수 없는 오류가 발생했습니다.';
  }

  static bool isRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
           errorString.contains('timeout') ||
           errorString.contains('500') ||
           errorString.contains('502') ||
           errorString.contains('503') ||
           errorString.contains('504');
  }
}
