import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/package_model.dart';
import '../../data/api/admin_service.dart';
import 'admin_dashboard_provider.dart';

// Search and filter providers
final productSearchProvider = StateProvider<String>((ref) => '');
final productCategoryFilterProvider = StateProvider<String?>((ref) => null);
final productStatusFilterProvider = StateProvider<String?>((ref) => null);

// Products list provider with filtering
final productsProvider = FutureProvider<List<PackageModel>>((ref) async {
  final adminService = ref.read(adminServiceProvider);
  final search = ref.watch(productSearchProvider);
  final category = ref.watch(productCategoryFilterProvider);
  final status = ref.watch(productStatusFilterProvider);
  
  return await adminService.getProducts(
    search: search.isEmpty ? null : search,
    category: category,
    status: status,
  );
});

// Product management operations
final productManagementProvider = StateNotifierProvider<ProductManagementNotifier, AsyncValue<void>>((ref) {
  return ProductManagementNotifier(ref.read(adminServiceProvider), ref);
});

class ProductManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminService _adminService;
  final Ref _ref;

  ProductManagementNotifier(this._adminService, this._ref) : super(const AsyncValue.data(null));

  Future<void> createProduct(PackageModel product) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.createProduct(product);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProduct(String id, PackageModel product) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.updateProduct(id, product);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.deleteProduct(id);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> activateProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.activateProduct(id);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deactivateProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.deactivateProduct(id);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePrice(String id, Map<String, dynamic> priceData) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.updateProductPrice(id, priceData);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createPromotion(String id, Map<String, dynamic> promotionData) async {
    state = const AsyncValue.loading();
    try {
      await _adminService.createPromotion(id, promotionData);
      state = const AsyncValue.data(null);
      // Refresh products list
      _ref.invalidate(productsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}