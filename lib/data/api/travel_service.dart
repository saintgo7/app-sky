import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/travel_package_model.dart';
import '../models/hotel_model.dart';
import '../models/flight_model.dart';

part 'travel_service.g.dart';

@RestApi()
abstract class TravelService {
  factory TravelService(Dio dio, {String? baseUrl}) = _TravelService;

  // Package Search and Filtering
  @GET('/packages')
  Future<PackageSearchResponse> searchPackages(@Queries() PackageSearchQuery query);

  @GET('/packages/{id}')
  Future<TravelPackageModel> getPackage(@Path('id') String id);

  @GET('/packages/{id}/similar')
  Future<List<TravelPackageModel>> getSimilarPackages(@Path('id') String id, @Query('limit') int limit);

  @GET('/packages/popular')
  Future<List<TravelPackageModel>> getPopularPackages(@Query('limit') int? limit);

  @GET('/packages/featured')
  Future<List<TravelPackageModel>> getFeaturedPackages(@Query('limit') int? limit);

  @GET('/packages/last-minute-deals')
  Future<List<TravelPackageModel>> getLastMinuteDeals(@Query('limit') int? limit);

  // Hotel Search
  @GET('/hotels')
  Future<HotelSearchResponse> searchHotels(@Queries() HotelSearchQuery query);

  @GET('/hotels/{id}')
  Future<HotelModel> getHotel(@Path('id') String id);

  @GET('/hotels/{id}/availability')
  Future<HotelAvailabilityResponse> getHotelAvailability(
    @Path('id') String id,
    @Queries() AvailabilityQuery query,
  );

  @GET('/hotels/{id}/pricing')
  Future<HotelPricingResponse> getHotelPricing(
    @Path('id') String id,
    @Queries() PricingQuery query,
  );

  // Flight Search
  @GET('/flights')
  Future<FlightSearchResponse> searchFlights(@Queries() FlightSearchQuery query);

  @GET('/flights/{id}')
  Future<FlightModel> getFlight(@Path('id') String id);

  @GET('/flights/routes/{origin}/{destination}')
  Future<List<FlightModel>> getFlightsByRoute(
    @Path('origin') String origin,
    @Path('destination') String destination,
    @Queries() FlightRouteQuery query,
  );

  // Destinations
  @GET('/destinations')
  Future<DestinationSearchResponse> searchDestinations(@Queries() DestinationSearchQuery query);

  @GET('/destinations/{id}')
  Future<DestinationModel> getDestination(@Path('id') String id);

  @GET('/destinations/trending')
  Future<List<DestinationModel>> getTrendingDestinations(@Query('limit') int? limit);

  @GET('/destinations/{id}/weather')
  Future<WeatherInfoResponse> getDestinationWeather(@Path('id') String id, @Query('date') String? date);

  // Activities and Attractions
  @GET('/activities')
  Future<ActivitySearchResponse> searchActivities(@Queries() ActivitySearchQuery query);

  @GET('/activities/{id}')
  Future<ActivityModel> getActivity(@Path('id') String id);

  // Reviews and Ratings
  @GET('/packages/{id}/reviews')
  Future<ReviewListResponse> getPackageReviews(@Path('id') String id, @Queries() ReviewQuery query);

  @POST('/packages/{id}/reviews')
  Future<ReviewModel> createPackageReview(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() CreateReviewRequest request,
  );

  @GET('/hotels/{id}/reviews')
  Future<ReviewListResponse> getHotelReviews(@Path('id') String id, @Queries() ReviewQuery query);

  // Wishlist and Favorites
  @GET('/favorites')
  Future<FavoriteListResponse> getFavorites(@Header('Authorization') String token, @Query('type') String? type);

  @POST('/favorites')
  Future<void> addToFavorites(@Header('Authorization') String token, @Body() AddFavoriteRequest request);

  @DELETE('/favorites/{itemId}')
  Future<void> removeFromFavorites(@Header('Authorization') String token, @Path('itemId') String itemId);

  // Comparison
  @POST('/compare')
  Future<ComparisonResponse> comparePackages(@Body() ComparePackagesRequest request);

  // Real-time Pricing Updates
  @GET('/packages/{id}/live-pricing')
  Future<LivePricingResponse> getLivePricing(@Path('id') String id, @Queries() LivePricingQuery query);
}

// Search Query Models
@JsonSerializable()
class PackageSearchQuery {
  final String? destination;
  final List<String>? countries;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minDuration;
  final int? maxDuration;
  final double? minPrice;
  final double? maxPrice;
  final String? currency;
  final PackageType? packageType;
  final int? travelers;
  final List<String>? categories;
  final List<String>? activities;
  final double? minRating;
  final String? sortBy;
  final String? sortOrder;
  final int? page;
  final int? limit;

  const PackageSearchQuery({
    this.destination,
    this.countries,
    this.startDate,
    this.endDate,
    this.minDuration,
    this.maxDuration,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.packageType,
    this.travelers,
    this.categories,
    this.activities,
    this.minRating,
    this.sortBy,
    this.sortOrder,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$PackageSearchQueryToJson(this);
}

@JsonSerializable()
class HotelSearchQuery {
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;
  final int? minStarRating;
  final int? maxStarRating;
  final double? minPrice;
  final double? maxPrice;
  final String? currency;
  final List<String>? amenities;
  final List<String>? facilities;
  final double? minRating;
  final String? sortBy;
  final String? sortOrder;
  final int? page;
  final int? limit;

  const HotelSearchQuery({
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.checkIn,
    this.checkOut,
    this.adults,
    this.children,
    this.rooms,
    this.minStarRating,
    this.maxStarRating,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.amenities,
    this.facilities,
    this.minRating,
    this.sortBy,
    this.sortOrder,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$HotelSearchQueryToJson(this);
}

@JsonSerializable()
class FlightSearchQuery {
  final String origin;
  final String destination;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final SeatClass? seatClass;
  final FlightType? flightType;
  final bool directFlightOnly;
  final double? maxPrice;
  final String? currency;
  final String? airline;
  final String? sortBy;
  final String? sortOrder;
  final int? page;
  final int? limit;

  const FlightSearchQuery({
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    this.seatClass,
    this.flightType,
    this.directFlightOnly = false,
    this.maxPrice,
    this.currency,
    this.airline,
    this.sortBy,
    this.sortOrder,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$FlightSearchQueryToJson(this);
}

@JsonSerializable()
class DestinationSearchQuery {
  final String? query;
  final String? region;
  final List<String>? activities;
  final String? climate;
  final String? budgetRange;
  final String? season;
  final List<String>? travelStyle;
  final int? page;
  final int? limit;

  const DestinationSearchQuery({
    this.query,
    this.region,
    this.activities,
    this.climate,
    this.budgetRange,
    this.season,
    this.travelStyle,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$DestinationSearchQueryToJson(this);
}

@JsonSerializable()
class ActivitySearchQuery {
  final String? destination;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? currency;
  final DateTime? date;
  final int? duration;
  final double? minRating;
  final String? sortBy;
  final String? sortOrder;
  final int? page;
  final int? limit;

  const ActivitySearchQuery({
    this.destination,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.date,
    this.duration,
    this.minRating,
    this.sortBy,
    this.sortOrder,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$ActivitySearchQueryToJson(this);
}

// Response Models
@JsonSerializable()
class PackageSearchResponse {
  final List<TravelPackageModel> packages;
  final int totalCount;
  final int page;
  final int totalPages;
  final SearchFilters availableFilters;

  const PackageSearchResponse({
    required this.packages,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.availableFilters,
  });

  factory PackageSearchResponse.fromJson(Map<String, dynamic> json) => _$PackageSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PackageSearchResponseToJson(this);
}

@JsonSerializable()
class HotelSearchResponse {
  final List<HotelModel> hotels;
  final int totalCount;
  final int page;
  final int totalPages;
  final SearchFilters availableFilters;

  const HotelSearchResponse({
    required this.hotels,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.availableFilters,
  });

  factory HotelSearchResponse.fromJson(Map<String, dynamic> json) => _$HotelSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HotelSearchResponseToJson(this);
}

@JsonSerializable()
class FlightSearchResponse {
  final List<FlightModel> flights;
  final int totalCount;
  final int page;
  final int totalPages;
  final FlightSearchMeta meta;

  const FlightSearchResponse({
    required this.flights,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.meta,
  });

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) => _$FlightSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FlightSearchResponseToJson(this);
}

@JsonSerializable()
class DestinationSearchResponse {
  final List<DestinationModel> destinations;
  final int totalCount;
  final int page;
  final int totalPages;

  const DestinationSearchResponse({
    required this.destinations,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });

  factory DestinationSearchResponse.fromJson(Map<String, dynamic> json) => _$DestinationSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationSearchResponseToJson(this);
}

@JsonSerializable()
class ActivitySearchResponse {
  final List<ActivityModel> activities;
  final int totalCount;
  final int page;
  final int totalPages;

  const ActivitySearchResponse({
    required this.activities,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });

  factory ActivitySearchResponse.fromJson(Map<String, dynamic> json) => _$ActivitySearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ActivitySearchResponseToJson(this);
}

// Additional Models
@JsonSerializable()
class SearchFilters {
  final List<FilterOption> destinations;
  final List<FilterOption> categories;
  final List<FilterOption> priceRanges;
  final List<FilterOption> durations;
  final List<FilterOption> ratings;

  const SearchFilters({
    required this.destinations,
    required this.categories,
    required this.priceRanges,
    required this.durations,
    required this.ratings,
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) => _$SearchFiltersFromJson(json);
  Map<String, dynamic> toJson() => _$SearchFiltersToJson(this);
}

@JsonSerializable()
class FilterOption {
  final String value;
  final String label;
  final int count;

  const FilterOption({
    required this.value,
    required this.label,
    required this.count,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) => _$FilterOptionFromJson(json);
  Map<String, dynamic> toJson() => _$FilterOptionToJson(this);
}

@JsonSerializable()
class FlightSearchMeta {
  final String origin;
  final String destination;
  final DateTime searchDate;
  final int totalRoutes;
  final List<String> availableAirlines;
  final PriceRange priceRange;

  const FlightSearchMeta({
    required this.origin,
    required this.destination,
    required this.searchDate,
    required this.totalRoutes,
    required this.availableAirlines,
    required this.priceRange,
  });

  factory FlightSearchMeta.fromJson(Map<String, dynamic> json) => _$FlightSearchMetaFromJson(json);
  Map<String, dynamic> toJson() => _$FlightSearchMetaToJson(this);
}

@JsonSerializable()
class PriceRange {
  final double min;
  final double max;
  final String currency;

  const PriceRange({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) => _$PriceRangeFromJson(json);
  Map<String, dynamic> toJson() => _$PriceRangeToJson(this);
}

@JsonSerializable()
class DestinationModel {
  final String id;
  final String name;
  final String country;
  final String region;
  final String description;
  final List<String> images;
  final String? thumbnailImage;
  final double latitude;
  final double longitude;
  final String timezone;
  final List<String> popularActivities;
  final String climate;
  final String bestTimeToVisit;
  final double averageRating;
  final int reviewCount;
  final List<String> tags;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.description,
    required this.images,
    this.thumbnailImage,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.popularActivities,
    required this.climate,
    required this.bestTimeToVisit,
    required this.averageRating,
    required this.reviewCount,
    required this.tags,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) => _$DestinationModelFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationModelToJson(this);
}

@JsonSerializable()
class ActivityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String destination;
  final double price;
  final String currency;
  final int durationMinutes;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String? thumbnailImage;
  final List<String> inclusions;
  final List<String> requirements;
  final bool instantBooking;

  const ActivityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.destination,
    required this.price,
    required this.currency,
    required this.durationMinutes,
    required this.rating,
    required this.reviewCount,
    required this.images,
    this.thumbnailImage,
    required this.inclusions,
    required this.requirements,
    required this.instantBooking,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}

@JsonSerializable()
class WeatherInfoResponse {
  final String destination;
  final DateTime date;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String temperatureUnit;
  final List<WeatherForecast>? forecast;

  const WeatherInfoResponse({
    required this.destination,
    required this.date,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.temperatureUnit,
    this.forecast,
  });

  factory WeatherInfoResponse.fromJson(Map<String, dynamic> json) => _$WeatherInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherInfoResponseToJson(this);
}

@JsonSerializable()
class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final int humidity;

  const WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.humidity,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) => _$WeatherForecastFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}

// Additional Helper Models
@JsonSerializable()
class AvailabilityQuery {
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int rooms;

  const AvailabilityQuery({
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.rooms,
  });

  Map<String, dynamic> toJson() => _$AvailabilityQueryToJson(this);
}

@JsonSerializable()
class PricingQuery {
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int rooms;
  final String? currency;

  const PricingQuery({
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.rooms,
    this.currency,
  });

  Map<String, dynamic> toJson() => _$PricingQueryToJson(this);
}

@JsonSerializable()
class FlightRouteQuery {
  final DateTime? date;
  final SeatClass? seatClass;
  final int? passengers;
  final String? sortBy;
  final int? limit;

  const FlightRouteQuery({
    this.date,
    this.seatClass,
    this.passengers,
    this.sortBy,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$FlightRouteQueryToJson(this);
}

@JsonSerializable()
class ReviewQuery {
  final int? page;
  final int? limit;
  final int? minRating;
  final String? sortBy;
  final String? sortOrder;

  const ReviewQuery({
    this.page,
    this.limit,
    this.minRating,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() => _$ReviewQueryToJson(this);
}

@JsonSerializable()
class ReviewListResponse {
  final List<ReviewModel> reviews;
  final int totalCount;
  final int page;
  final int totalPages;
  final ReviewStats stats;

  const ReviewListResponse({
    required this.reviews,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.stats,
  });

  factory ReviewListResponse.fromJson(Map<String, dynamic> json) => _$ReviewListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewListResponseToJson(this);
}

@JsonSerializable()
class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String title;
  final String comment;
  final List<String>? images;
  final DateTime createdAt;
  final int helpfulCount;
  final bool isVerified;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.title,
    required this.comment,
    this.images,
    required this.createdAt,
    required this.helpfulCount,
    required this.isVerified,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  const ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) => _$ReviewStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewStatsToJson(this);
}

@JsonSerializable()
class CreateReviewRequest {
  final int rating;
  final String title;
  final String comment;
  final List<String>? images;

  const CreateReviewRequest({
    required this.rating,
    required this.title,
    required this.comment,
    this.images,
  });

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) => _$CreateReviewRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);
}

@JsonSerializable()
class FavoriteListResponse {
  final List<FavoriteItem> favorites;
  final int totalCount;

  const FavoriteListResponse({
    required this.favorites,
    required this.totalCount,
  });

  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) => _$FavoriteListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteListResponseToJson(this);
}

@JsonSerializable()
class FavoriteItem {
  final String id;
  final String itemId;
  final String itemType;
  final String title;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.title,
    this.imageUrl,
    this.price,
    this.currency,
    required this.addedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => _$FavoriteItemFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteItemToJson(this);
}

@JsonSerializable()
class AddFavoriteRequest {
  final String itemId;
  final String itemType;

  const AddFavoriteRequest({
    required this.itemId,
    required this.itemType,
  });

  factory AddFavoriteRequest.fromJson(Map<String, dynamic> json) => _$AddFavoriteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddFavoriteRequestToJson(this);
}

@JsonSerializable()
class ComparePackagesRequest {
  final List<String> packageIds;

  const ComparePackagesRequest({required this.packageIds});

  factory ComparePackagesRequest.fromJson(Map<String, dynamic> json) => _$ComparePackagesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ComparePackagesRequestToJson(this);
}

@JsonSerializable()
class ComparisonResponse {
  final List<TravelPackageModel> packages;
  final ComparisonMatrix comparisonMatrix;

  const ComparisonResponse({
    required this.packages,
    required this.comparisonMatrix,
  });

  factory ComparisonResponse.fromJson(Map<String, dynamic> json) => _$ComparisonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ComparisonResponseToJson(this);
}

@JsonSerializable()
class ComparisonMatrix {
  final Map<String, Map<String, dynamic>> features;

  const ComparisonMatrix({required this.features});

  factory ComparisonMatrix.fromJson(Map<String, dynamic> json) => _$ComparisonMatrixFromJson(json);
  Map<String, dynamic> toJson() => _$ComparisonMatrixToJson(this);
}

@JsonSerializable()
class LivePricingQuery {
  final DateTime? travelDate;
  final int? travelers;
  final String? currency;

  const LivePricingQuery({
    this.travelDate,
    this.travelers,
    this.currency,
  });

  Map<String, dynamic> toJson() => _$LivePricingQueryToJson(this);
}

@JsonSerializable()
class LivePricingResponse {
  final String packageId;
  final double currentPrice;
  final double? originalPrice;
  final String currency;
  final DateTime lastUpdated;
  final List<PriceAlert>? alerts;
  final PriceTrend trend;

  const LivePricingResponse({
    required this.packageId,
    required this.currentPrice,
    this.originalPrice,
    required this.currency,
    required this.lastUpdated,
    this.alerts,
    required this.trend,
  });

  factory LivePricingResponse.fromJson(Map<String, dynamic> json) => _$LivePricingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LivePricingResponseToJson(this);
}

@JsonSerializable()
class PriceAlert {
  final String type;
  final String message;
  final DateTime? expiresAt;

  const PriceAlert({
    required this.type,
    required this.message,
    this.expiresAt,
  });

  factory PriceAlert.fromJson(Map<String, dynamic> json) => _$PriceAlertFromJson(json);
  Map<String, dynamic> toJson() => _$PriceAlertToJson(this);
}

@JsonSerializable()
class PriceTrend {
  final String direction; // 'up', 'down', 'stable'
  final double changePercent;
  final List<PricePoint> history;

  const PriceTrend({
    required this.direction,
    required this.changePercent,
    required this.history,
  });

  factory PriceTrend.fromJson(Map<String, dynamic> json) => _$PriceTrendFromJson(json);
  Map<String, dynamic> toJson() => _$PriceTrendToJson(this);
}

@JsonSerializable()
class PricePoint {
  final DateTime date;
  final double price;

  const PricePoint({
    required this.date,
    required this.price,
  });

  factory PricePoint.fromJson(Map<String, dynamic> json) => _$PricePointFromJson(json);
  Map<String, dynamic> toJson() => _$PricePointToJson(this);
}

@JsonSerializable()
class HotelAvailabilityResponse {
  final String hotelId;
  final DateTime checkIn;
  final DateTime checkOut;
  final List<RoomAvailability> roomAvailability;
  final DateTime lastUpdated;

  const HotelAvailabilityResponse({
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    required this.roomAvailability,
    required this.lastUpdated,
  });

  factory HotelAvailabilityResponse.fromJson(Map<String, dynamic> json) => _$HotelAvailabilityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HotelAvailabilityResponseToJson(this);
}

@JsonSerializable()
class HotelPricingResponse {
  final String hotelId;
  final DateTime checkIn;
  final DateTime checkOut;
  final List<RoomPricing> roomPricing;
  final DateTime lastUpdated;

  const HotelPricingResponse({
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    required this.roomPricing,
    required this.lastUpdated,
  });

  factory HotelPricingResponse.fromJson(Map<String, dynamic> json) => _$HotelPricingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HotelPricingResponseToJson(this);
}

@JsonSerializable()
class RoomAvailability {
  final String roomTypeId;
  final String roomTypeName;
  final int availableRooms;
  final int totalRooms;

  const RoomAvailability({
    required this.roomTypeId,
    required this.roomTypeName,
    required this.availableRooms,
    required this.totalRooms,
  });

  factory RoomAvailability.fromJson(Map<String, dynamic> json) => _$RoomAvailabilityFromJson(json);
  Map<String, dynamic> toJson() => _$RoomAvailabilityToJson(this);
}

@JsonSerializable()
class RoomPricing {
  final String roomTypeId;
  final String roomTypeName;
  final double totalPrice;
  final double pricePerNight;
  final String currency;
  final List<PriceBreakdown>? breakdown;

  const RoomPricing({
    required this.roomTypeId,
    required this.roomTypeName,
    required this.totalPrice,
    required this.pricePerNight,
    required this.currency,
    this.breakdown,
  });

  factory RoomPricing.fromJson(Map<String, dynamic> json) => _$RoomPricingFromJson(json);
  Map<String, dynamic> toJson() => _$RoomPricingToJson(this);
}

@JsonSerializable()
class PriceBreakdown {
  final String itemType;
  final String description;
  final double amount;
  final int quantity;

  const PriceBreakdown({
    required this.itemType,
    required this.description,
    required this.amount,
    required this.quantity,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) => _$PriceBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$PriceBreakdownToJson(this);
}