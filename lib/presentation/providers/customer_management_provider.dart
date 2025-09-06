import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/api/admin_service.dart';
import 'admin_dashboard_provider.dart';

// Search and filter providers
final customerSearchProvider = StateProvider<String>((ref) => '');
final customerTypeFilterProvider = StateProvider<String?>((ref) => null);
final customerStatusFilterProvider = StateProvider<String?>((ref) => null);

// Customers list provider with filtering
final customersProvider = FutureProvider<List<UserModel>>((ref) async {
  final adminService = ref.read(adminServiceProvider);
  final search = ref.watch(customerSearchProvider);
  final type = ref.watch(customerTypeFilterProvider);
  final status = ref.watch(customerStatusFilterProvider);
  
  return await adminService.getCustomers(
    search: search.isEmpty ? null : search,
    type: type,
    status: status,
  );
});

// Customer bookings provider
final customerBookingsProvider = FutureProvider.family<List<BookingModel>, String>((ref, customerId) async {
  final adminService = ref.read(adminServiceProvider);
  return await adminService.getCustomerBookings(customerId);
});

// Customer management operations
final customerManagementProvider = StateNotifierProvider<CustomerManagementNotifier, AsyncValue<void>>((ref) {
  return CustomerManagementNotifier(ref.read(adminServiceProvider), ref);
});

class CustomerManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminService _adminService;
  final Ref _ref;

  CustomerManagementNotifier(this._adminService, this._ref) : super(const AsyncValue.data(null));

  Future<void> updateVipStatus(String customerId, bool isVip) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.updateVipStatus(customerId, {
        'isVip': isVip,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      state = const AsyncValue.data(null);
      // Refresh customers list
      _ref.invalidate(customersProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addToBlacklist(String customerId, String reason) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.addToBlacklist(customerId, {
        'reason': reason,
        'blacklistedAt': DateTime.now().toIso8601String(),
      });
      state = const AsyncValue.data(null);
      // Refresh customers list
      _ref.invalidate(customersProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeFromBlacklist(String customerId) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.removeFromBlacklist(customerId);
      state = const AsyncValue.data(null);
      // Refresh customers list
      _ref.invalidate(customersProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Additional providers for customer statistics
final vipCustomersCountProvider = Provider<int>((ref) {
  final customers = ref.watch(customersProvider).valueOrNull ?? [];
  return customers.where((c) => c.isVip ?? false).length;
});

final blacklistedCustomersCountProvider = Provider<int>((ref) {
  final customers = ref.watch(customersProvider).valueOrNull ?? [];
  return customers.where((c) => c.isBlacklisted ?? false).length;
});

final activeCustomersCountProvider = Provider<int>((ref) {
  final customers = ref.watch(customersProvider).valueOrNull ?? [];
  return customers.where((c) => 
    !(c.isBlacklisted ?? false) && 
    c.lastActivityAt != null &&
    c.lastActivityAt!.isAfter(DateTime.now().subtract(const Duration(days: 30)))
  ).length;
});