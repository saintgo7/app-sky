import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/api/admin_service.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../../core/environment/app_environment.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppEnvironment.apiUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  // Add auth interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add auth token to headers
      // This should be implemented based on your auth system
      handler.next(options);
    },
  ));
  
  return AdminService(dio);
});

final adminDashboardProvider = StateNotifierProvider<AdminDashboardNotifier, AsyncValue<AdminDashboardData>>((ref) {
  return AdminDashboardNotifier(ref.read(adminServiceProvider));
});

class AdminDashboardNotifier extends StateNotifier<AsyncValue<AdminDashboardData>> {
  final AdminService _adminService;
  Timer? _refreshTimer;

  AdminDashboardNotifier(this._adminService) : super(const AsyncValue.loading()) {
    loadDashboardData();
    _startAutoRefresh();
  }

  Future<void> loadDashboardData() async {
    try {
      state = const AsyncValue.loading();
      final data = await _adminService.getDashboardData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshDashboardData() async {
    try {
      final data = await _adminService.getRealtimeDashboardData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      // Keep previous data on refresh error
      if (state.hasValue) {
        // Optionally show a toast or notification about refresh failure
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => refreshDashboardData(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

// Additional providers for specific dashboard metrics
final bookingStatisticsProvider = Provider<BookingStatistics?>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.bookingStats;
});

final revenueStatisticsProvider = Provider<RevenueStatistics?>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.revenueStats;
});

final customerStatisticsProvider = Provider<CustomerStatistics?>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.customerStats;
});

final aiRecommendationStatsProvider = Provider<AIRecommendationStats?>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.aiStats;
});

final recentBookingsProvider = Provider<List<RecentBooking>>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.recentBookings ?? [];
});

final pendingInquiriesProvider = Provider<List<CustomerInquiry>>((ref) {
  return ref.watch(adminDashboardProvider).valueOrNull?.pendingInquiries ?? [];
});