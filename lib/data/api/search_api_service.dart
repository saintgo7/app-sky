import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/search_models.dart';
import 'base_api_client.dart';

part 'search_api_service.g.dart';

@RestApi()
abstract class SearchApiService {
  factory SearchApiService(Dio dio, {String baseUrl}) = _SearchApiService;

  static SearchApiService create() {
    return SearchApiService(BaseApiClient().dio);
  }

  // Destinations
  @GET('/destinations')
  Future<DestinationListResponse> searchDestinations({
    @Query('query') String? query,
    @Query('category') String? category,
    @Query('country') String? country,
    @Query('city') String? city,
    @Query('min_rating') double? minRating,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
    @Query('sort_by') String sortBy = 'rating',
    @Query('sort_order') String sortOrder = 'desc',
  });

  @GET('/destinations/{id}')
  Future<DestinationDetailResponse> getDestinationDetails(
    @Path('id') String id,
    @Query('include_attractions') bool includeAttractions = true,
  );

  @GET('/destinations/popular')
  Future<DestinationListResponse> getPopularDestinations({
    @Query('limit') int limit = 10,
    @Query('category') String? category,
  });

  @GET('/destinations/nearby')
  Future<DestinationListResponse> getNearbyDestinations({
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('radius') double radius = 50.0,
    @Query('limit') int limit = 20,
  });

  @GET('/destinations/categories')
  Future<CategoryListResponse> getDestinationCategories();

  // Flights
  @GET('/flights/search')
  Future<FlightListResponse> searchFlights({
    @Query('departure_city') required String departureCity,
    @Query('arrival_city') required String arrivalCity,
    @Query('departure_date') required String departureDate,
    @Query('return_date') String? returnDate,
    @Query('passengers') int passengers = 1,
    @Query('flight_class') String? flightClass,
    @Query('airlines') List<String>? airlines,
    @Query('max_price') double? maxPrice,
    @Query('stops') String? stops, // 'direct', 'one_stop', 'any'
  });

  @GET('/flights/{id}')
  Future<FlightDetailResponse> getFlightDetails(@Path('id') String id);

  @GET('/flights/airports')
  Future<AirportListResponse> searchAirports({
    @Query('query') required String query,
    @Query('limit') int limit = 10,
  });

  @GET('/flights/airlines')
  Future<AirlineListResponse> getAirlines();

  // Hotels
  @GET('/hotels/search')
  Future<HotelListResponse> searchHotels({
    @Query('city') required String city,
    @Query('check_in') required String checkIn,
    @Query('check_out') required String checkOut,
    @Query('guests') int guests = 1,
    @Query('rooms') int rooms = 1,
    @Query('max_price') double? maxPrice,
    @Query('min_rating') double? minRating,
    @Query('amenities') List<String>? amenities,
    @Query('chains') List<String>? chains,
  });

  @GET('/hotels/{id}')
  Future<HotelDetailResponse> getHotelDetails(@Path('id') String id);

  @GET('/hotels/chains')
  Future<HotelChainListResponse> getHotelChains();

  // Packages
  @GET('/packages/search')
  Future<PackageListResponse> searchPackages({
    @Query('query') String? query,
    @Query('departure_city') String? departureCity,
    @Query('destination') String? destination,
    @Query('duration') int? duration,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('themes') List<String>? themes,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  @GET('/packages/{id}')
  Future<PackageDetailResponse> getPackageDetails(@Path('id') String id);

  // General Search
  @GET('/search')
  Future<GeneralSearchResponse> generalSearch({
    @Query('query') required String query,
    @Query('type') String? type, // 'all', 'destinations', 'flights', 'hotels', 'packages'
    @Query('limit') int limit = 10,
  });

  // Auto-complete
  @GET('/search/autocomplete')
  Future<AutocompleteResponse> autocomplete({
    @Query('query') required String query,
    @Query('type') String? type,
    @Query('limit') int limit = 5,
  });
}
