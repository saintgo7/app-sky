import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/admin_dashboard_model.dart';
import '../models/user_model.dart';
import '../models/package_model.dart';
import '../models/booking_model.dart';

part 'admin_service.g.dart';

@RestApi()
abstract class AdminService {
  factory AdminService(Dio dio, {String baseUrl}) = _AdminService;

  // Dashboard
  @GET('/admin/dashboard')
  Future<AdminDashboardData> getDashboardData();

  @GET('/admin/dashboard/realtime')
  Future<AdminDashboardData> getRealtimeDashboardData();

  // Product Management
  @GET('/admin/products')
  Future<List<PackageModel>> getProducts({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('category') String? category,
    @Query('status') String? status,
  });

  @GET('/admin/products/{id}')
  Future<PackageModel> getProductById(@Path('id') String id);

  @POST('/admin/products')
  Future<PackageModel> createProduct(@Body() PackageModel product);

  @PUT('/admin/products/{id}')
  Future<PackageModel> updateProduct(
    @Path('id') String id,
    @Body() PackageModel product,
  );

  @DELETE('/admin/products/{id}')
  Future<void> deleteProduct(@Path('id') String id);

  @POST('/admin/products/{id}/activate')
  Future<void> activateProduct(@Path('id') String id);

  @POST('/admin/products/{id}/deactivate')
  Future<void> deactivateProduct(@Path('id') String id);

  // Price Management
  @PUT('/admin/products/{id}/price')
  Future<void> updateProductPrice(
    @Path('id') String id,
    @Body() Map<String, dynamic> priceData,
  );

  @POST('/admin/products/{id}/promotion')
  Future<void> createPromotion(
    @Path('id') String id,
    @Body() Map<String, dynamic> promotionData,
  );

  // Customer Management
  @GET('/admin/customers')
  Future<List<UserModel>> getCustomers({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('type') String? type,
    @Query('status') String? status,
  });

  @GET('/admin/customers/{id}')
  Future<UserModel> getCustomerById(@Path('id') String id);

  @GET('/admin/customers/{id}/bookings')
  Future<List<BookingModel>> getCustomerBookings(
    @Path('id') String id, {
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @PUT('/admin/customers/{id}/vip')
  Future<void> updateVipStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> vipData,
  );

  @POST('/admin/customers/{id}/blacklist')
  Future<void> addToBlacklist(
    @Path('id') String id,
    @Body() Map<String, dynamic> blacklistData,
  );

  @DELETE('/admin/customers/{id}/blacklist')
  Future<void> removeFromBlacklist(@Path('id') String id);

  // Analytics
  @GET('/admin/analytics/sales')
  Future<Map<String, dynamic>> getSalesAnalytics({
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('groupBy') String? groupBy,
  });

  @GET('/admin/analytics/ai-recommendations')
  Future<Map<String, dynamic>> getAIRecommendationAnalytics({
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });

  @GET('/admin/analytics/customer-satisfaction')
  Future<Map<String, dynamic>> getCustomerSatisfactionAnalytics();

  @GET('/admin/analytics/retention')
  Future<Map<String, dynamic>> getRetentionAnalytics();

  @GET('/admin/analytics/export')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> exportAnalytics({
    @Query('type') required String type,
    @Query('format') required String format,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });
}