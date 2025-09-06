import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

final adminAuthProvider = StateNotifierProvider<AdminAuthNotifier, AdminAuthState>((ref) {
  return AdminAuthNotifier(ref.read(authRepositoryProvider));
});

class AdminAuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final bool hasAdminAccess;

  AdminAuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.hasAdminAccess = false,
  });

  AdminAuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool? hasAdminAccess,
  }) {
    return AdminAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasAdminAccess: hasAdminAccess ?? this.hasAdminAccess,
    );
  }
}

class AdminAuthNotifier extends StateNotifier<AdminAuthState> {
  final AuthRepository _authRepository;

  AdminAuthNotifier(this._authRepository) : super(AdminAuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _authRepository.getAccessToken();
      if (token != null) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          final hasAccess = _checkAdminAccess(user);
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            hasAdminAccess: hasAccess,
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            isAuthenticated: false,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  bool _checkAdminAccess(UserModel user) {
    return user.role == UserRole.admin || user.role == UserRole.superAdmin;
  }

  bool hasPermission(String permission) {
    if (state.user == null) return false;
    
    switch (state.user!.role) {
      case UserRole.superAdmin:
        return true; // Super admin has all permissions
      case UserRole.admin:
        return _adminPermissions.contains(permission);
      case UserRole.groupAdmin:
        return _groupAdminPermissions.contains(permission);
      default:
        return false;
    }
  }

  static const _adminPermissions = [
    'view_dashboard',
    'manage_products',
    'manage_customers',
    'view_analytics',
    'manage_bookings',
    'manage_promotions',
    'view_reports',
  ];

  static const _groupAdminPermissions = [
    'view_group_dashboard',
    'manage_group_bookings',
    'view_group_analytics',
  ];

  Future<void> logout() async {
    await _authRepository.logout();
    state = AdminAuthState();
  }
}

// Permission constants
class AdminPermissions {
  static const viewDashboard = 'view_dashboard';
  static const manageProducts = 'manage_products';
  static const manageCustomers = 'manage_customers';
  static const viewAnalytics = 'view_analytics';
  static const manageBookings = 'manage_bookings';
  static const managePromotions = 'manage_promotions';
  static const viewReports = 'view_reports';
  static const manageUsers = 'manage_users';
  static const manageSystem = 'manage_system';
}