import '../../domain/entities/destination.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/hotel.dart';

// Base Response
class BaseResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? metadata;

  const BaseResponse({
    required this.success,
    this.message,
    this.metadata,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
    );
  }
}

// Destination Responses
class DestinationListResponse extends BaseResponse {
  final List<Destination> destinations;
  final int totalCount;
  final int page;
  final int limit;

  const DestinationListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.destinations,
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory DestinationListResponse.fromJson(Map<String, dynamic> json) {
    return DestinationListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      destinations: (json['data']['destinations'] as List)
          .map((dest) => DestinationJsonExtension.fromJson(dest))
          .toList(),
      totalCount: json['data']['total_count'] ?? 0,
      page: json['data']['page'] ?? 1,
      limit: json['data']['limit'] ?? 20,
    );
  }
}

class DestinationDetailResponse extends BaseResponse {
  final Destination destination;
  final List<Attraction>? attractions;

  const DestinationDetailResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.destination,
    this.attractions,
  });

  factory DestinationDetailResponse.fromJson(Map<String, dynamic> json) {
    return DestinationDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      destination: DestinationJsonExtension.fromJson(json['data']['destination']),
      attractions: json['data']['attractions'] != null
          ? (json['data']['attractions'] as List)
              .map((attr) => AttractionJsonExtension.fromJson(attr))
              .toList()
          : null,
    );
  }
}

class CategoryListResponse extends BaseResponse {
  final List<DestinationCategory> categories;

  const CategoryListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.categories,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      categories: (json['data']['categories'] as List)
          .map((cat) => DestinationCategoryJsonExtension.fromJson(cat))
          .toList(),
    );
  }
}

// Flight Responses
class FlightListResponse extends BaseResponse {
  final List<Flight> flights;
  final int totalCount;
  final SearchFilters? filters;
  final PriceRange? priceRange;

  const FlightListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.flights,
    required this.totalCount,
    this.filters,
    this.priceRange,
  });

  factory FlightListResponse.fromJson(Map<String, dynamic> json) {
    return FlightListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      flights: (json['data']['flights'] as List)
          .map((flight) => FlightJsonExtension.fromJson(flight))
          .toList(),
      totalCount: json['data']['total_count'] ?? 0,
      filters: json['data']['filters'] != null
          ? SearchFilters.fromJson(json['data']['filters'])
          : null,
      priceRange: json['data']['price_range'] != null
          ? PriceRange.fromJson(json['data']['price_range'])
          : null,
    );
  }
}

class FlightDetailResponse extends BaseResponse {
  final Flight flight;
  final List<AlternativeFlight>? alternatives;

  const FlightDetailResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.flight,
    this.alternatives,
  });

  factory FlightDetailResponse.fromJson(Map<String, dynamic> json) {
    return FlightDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      flight: FlightJsonExtension.fromJson(json['data']['flight']),
      alternatives: json['data']['alternatives'] != null
          ? (json['data']['alternatives'] as List)
              .map((alt) => AlternativeFlight.fromJson(alt))
              .toList()
          : null,
    );
  }
}

class AirportListResponse extends BaseResponse {
  final List<Airport> airports;

  const AirportListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.airports,
  });

  factory AirportListResponse.fromJson(Map<String, dynamic> json) {
    return AirportListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      airports: (json['data']['airports'] as List)
          .map((airport) => AirportJsonExtension.fromJson(airport))
          .toList(),
    );
  }
}

class AirlineListResponse extends BaseResponse {
  final List<Airline> airlines;

  const AirlineListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.airlines,
  });

  factory AirlineListResponse.fromJson(Map<String, dynamic> json) {
    return AirlineListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      airlines: (json['data']['airlines'] as List)
          .map((airline) => AirlineJsonExtension.fromJson(airline))
          .toList(),
    );
  }
}

// Hotel Responses
class HotelListResponse extends BaseResponse {
  final List<Hotel> hotels;
  final int totalCount;
  final SearchFilters? filters;
  final PriceRange? priceRange;

  const HotelListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.hotels,
    required this.totalCount,
    this.filters,
    this.priceRange,
  });

  factory HotelListResponse.fromJson(Map<String, dynamic> json) {
    return HotelListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      hotels: (json['data']['hotels'] as List)
          .map((hotel) => HotelJsonExtension.fromJson(hotel))
          .toList(),
      totalCount: json['data']['total_count'] ?? 0,
      filters: json['data']['filters'] != null
          ? SearchFilters.fromJson(json['data']['filters'])
          : null,
      priceRange: json['data']['price_range'] != null
          ? PriceRange.fromJson(json['data']['price_range'])
          : null,
    );
  }
}

class HotelDetailResponse extends BaseResponse {
  final Hotel hotel;
  final List<RoomType>? availableRooms;
  final List<String>? policies;

  const HotelDetailResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.hotel,
    this.availableRooms,
    this.policies,
  });

  factory HotelDetailResponse.fromJson(Map<String, dynamic> json) {
    return HotelDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      hotel: HotelJsonExtension.fromJson(json['data']['hotel']),
      availableRooms: json['data']['available_rooms'] != null
          ? (json['data']['available_rooms'] as List)
              .map((room) => RoomTypeJsonExtension.fromJson(room))
              .toList()
          : null,
      policies: json['data']['policies'] != null
          ? List<String>.from(json['data']['policies'])
          : null,
    );
  }
}

class HotelChainListResponse extends BaseResponse {
  final List<HotelChain> chains;

  const HotelChainListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.chains,
  });

  factory HotelChainListResponse.fromJson(Map<String, dynamic> json) {
    return HotelChainListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      chains: (json['data']['chains'] as List)
          .map((chain) => HotelChainJsonExtension.fromJson(chain))
          .toList(),
    );
  }
}

// Package Responses
class PackageListResponse extends BaseResponse {
  final List<TravelPackage> packages;
  final int totalCount;

  const PackageListResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.packages,
    required this.totalCount,
  });

  factory PackageListResponse.fromJson(Map<String, dynamic> json) {
    return PackageListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      packages: (json['data']['packages'] as List)
          .map((pkg) => TravelPackage.fromJson(pkg))
          .toList(),
      totalCount: json['data']['total_count'] ?? 0,
    );
  }
}

class PackageDetailResponse extends BaseResponse {
  final TravelPackage package;
  final List<ItineraryItem>? itinerary;
  final List<String>? inclusions;
  final List<String>? exclusions;

  const PackageDetailResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.package,
    this.itinerary,
    this.inclusions,
    this.exclusions,
  });

  factory PackageDetailResponse.fromJson(Map<String, dynamic> json) {
    return PackageDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      package: TravelPackage.fromJson(json['data']['package']),
      itinerary: json['data']['itinerary'] != null
          ? (json['data']['itinerary'] as List)
              .map((item) => ItineraryItem.fromJson(item))
              .toList()
          : null,
      inclusions: json['data']['inclusions'] != null
          ? List<String>.from(json['data']['inclusions'])
          : null,
      exclusions: json['data']['exclusions'] != null
          ? List<String>.from(json['data']['exclusions'])
          : null,
    );
  }
}

// General Search
class GeneralSearchResponse extends BaseResponse {
  final List<SearchResult> results;
  final SearchSuggestions? suggestions;

  const GeneralSearchResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.results,
    this.suggestions,
  });

  factory GeneralSearchResponse.fromJson(Map<String, dynamic> json) {
    return GeneralSearchResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      results: (json['data']['results'] as List)
          .map((result) => SearchResult.fromJson(result))
          .toList(),
      suggestions: json['data']['suggestions'] != null
          ? SearchSuggestions.fromJson(json['data']['suggestions'])
          : null,
    );
  }
}

class AutocompleteResponse extends BaseResponse {
  final List<String> suggestions;
  final String? category;

  const AutocompleteResponse({
    required super.success,
    super.message,
    super.metadata,
    required this.suggestions,
    this.category,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutocompleteResponse(
      success: json['success'] ?? false,
      message: json['message'],
      metadata: json['metadata'],
      suggestions: List<String>.from(json['data']['suggestions']),
      category: json['data']['category'],
    );
  }
}
