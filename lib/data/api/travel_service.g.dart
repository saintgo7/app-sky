// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageSearchQuery _$PackageSearchQueryFromJson(Map<String, dynamic> json) =>
    PackageSearchQuery(
      destination: json['destination'] as String?,
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      minDuration: (json['minDuration'] as num?)?.toInt(),
      maxDuration: (json['maxDuration'] as num?)?.toInt(),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      packageType:
          $enumDecodeNullable(_$PackageTypeEnumMap, json['packageType']),
      travelers: (json['travelers'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackageSearchQueryToJson(PackageSearchQuery instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'countries': instance.countries,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'minDuration': instance.minDuration,
      'maxDuration': instance.maxDuration,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
      'packageType': _$PackageTypeEnumMap[instance.packageType],
      'travelers': instance.travelers,
      'categories': instance.categories,
      'activities': instance.activities,
      'minRating': instance.minRating,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
      'page': instance.page,
      'limit': instance.limit,
    };

const _$PackageTypeEnumMap = {
  PackageType.package: 'package',
  PackageType.freeTravel: 'freeTravel',
  PackageType.customized: 'customized',
};

HotelSearchQuery _$HotelSearchQueryFromJson(Map<String, dynamic> json) =>
    HotelSearchQuery(
      city: json['city'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radiusKm: (json['radiusKm'] as num?)?.toDouble(),
      checkIn: json['checkIn'] == null
          ? null
          : DateTime.parse(json['checkIn'] as String),
      checkOut: json['checkOut'] == null
          ? null
          : DateTime.parse(json['checkOut'] as String),
      adults: (json['adults'] as num?)?.toInt(),
      children: (json['children'] as num?)?.toInt(),
      rooms: (json['rooms'] as num?)?.toInt(),
      minStarRating: (json['minStarRating'] as num?)?.toInt(),
      maxStarRating: (json['maxStarRating'] as num?)?.toInt(),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotelSearchQueryToJson(HotelSearchQuery instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
      'checkIn': instance.checkIn?.toIso8601String(),
      'checkOut': instance.checkOut?.toIso8601String(),
      'adults': instance.adults,
      'children': instance.children,
      'rooms': instance.rooms,
      'minStarRating': instance.minStarRating,
      'maxStarRating': instance.maxStarRating,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
      'amenities': instance.amenities,
      'facilities': instance.facilities,
      'minRating': instance.minRating,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
      'page': instance.page,
      'limit': instance.limit,
    };

FlightSearchQuery _$FlightSearchQueryFromJson(Map<String, dynamic> json) =>
    FlightSearchQuery(
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureDate: DateTime.parse(json['departureDate'] as String),
      returnDate: json['returnDate'] == null
          ? null
          : DateTime.parse(json['returnDate'] as String),
      passengers: (json['passengers'] as num).toInt(),
      seatClass: $enumDecodeNullable(_$SeatClassEnumMap, json['seatClass']),
      flightType: $enumDecodeNullable(_$FlightTypeEnumMap, json['flightType']),
      directFlightOnly: json['directFlightOnly'] as bool? ?? false,
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      airline: json['airline'] as String?,
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FlightSearchQueryToJson(FlightSearchQuery instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'departureDate': instance.departureDate.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
      'passengers': instance.passengers,
      'seatClass': _$SeatClassEnumMap[instance.seatClass],
      'flightType': _$FlightTypeEnumMap[instance.flightType],
      'directFlightOnly': instance.directFlightOnly,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
      'airline': instance.airline,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
      'page': instance.page,
      'limit': instance.limit,
    };

const _$SeatClassEnumMap = {
  SeatClass.economy: 'economy',
  SeatClass.business: 'business',
  SeatClass.first: 'first',
};

const _$FlightTypeEnumMap = {
  FlightType.domestic: 'domestic',
  FlightType.international: 'international',
};

DestinationSearchQuery _$DestinationSearchQueryFromJson(
        Map<String, dynamic> json) =>
    DestinationSearchQuery(
      query: json['query'] as String?,
      region: json['region'] as String?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      climate: json['climate'] as String?,
      budgetRange: json['budgetRange'] as String?,
      season: json['season'] as String?,
      travelStyle: (json['travelStyle'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DestinationSearchQueryToJson(
        DestinationSearchQuery instance) =>
    <String, dynamic>{
      'query': instance.query,
      'region': instance.region,
      'activities': instance.activities,
      'climate': instance.climate,
      'budgetRange': instance.budgetRange,
      'season': instance.season,
      'travelStyle': instance.travelStyle,
      'page': instance.page,
      'limit': instance.limit,
    };

ActivitySearchQuery _$ActivitySearchQueryFromJson(Map<String, dynamic> json) =>
    ActivitySearchQuery(
      destination: json['destination'] as String?,
      category: json['category'] as String?,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivitySearchQueryToJson(
        ActivitySearchQuery instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'category': instance.category,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration,
      'minRating': instance.minRating,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
      'page': instance.page,
      'limit': instance.limit,
    };

PackageSearchResponse _$PackageSearchResponseFromJson(
        Map<String, dynamic> json) =>
    PackageSearchResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => TravelPackageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      availableFilters: SearchFilters.fromJson(
          json['availableFilters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PackageSearchResponseToJson(
        PackageSearchResponse instance) =>
    <String, dynamic>{
      'packages': instance.packages,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'availableFilters': instance.availableFilters,
    };

HotelSearchResponse _$HotelSearchResponseFromJson(Map<String, dynamic> json) =>
    HotelSearchResponse(
      hotels: (json['hotels'] as List<dynamic>)
          .map((e) => HotelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      availableFilters: SearchFilters.fromJson(
          json['availableFilters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HotelSearchResponseToJson(
        HotelSearchResponse instance) =>
    <String, dynamic>{
      'hotels': instance.hotels,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'availableFilters': instance.availableFilters,
    };

FlightSearchResponse _$FlightSearchResponseFromJson(
        Map<String, dynamic> json) =>
    FlightSearchResponse(
      flights: (json['flights'] as List<dynamic>)
          .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      meta: FlightSearchMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlightSearchResponseToJson(
        FlightSearchResponse instance) =>
    <String, dynamic>{
      'flights': instance.flights,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'meta': instance.meta,
    };

DestinationSearchResponse _$DestinationSearchResponseFromJson(
        Map<String, dynamic> json) =>
    DestinationSearchResponse(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => DestinationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$DestinationSearchResponseToJson(
        DestinationSearchResponse instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
    };

ActivitySearchResponse _$ActivitySearchResponseFromJson(
        Map<String, dynamic> json) =>
    ActivitySearchResponse(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$ActivitySearchResponseToJson(
        ActivitySearchResponse instance) =>
    <String, dynamic>{
      'activities': instance.activities,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
    };

SearchFilters _$SearchFiltersFromJson(Map<String, dynamic> json) =>
    SearchFilters(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceRanges: (json['priceRanges'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      durations: (json['durations'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      ratings: (json['ratings'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchFiltersToJson(SearchFilters instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
      'categories': instance.categories,
      'priceRanges': instance.priceRanges,
      'durations': instance.durations,
      'ratings': instance.ratings,
    };

FilterOption _$FilterOptionFromJson(Map<String, dynamic> json) => FilterOption(
      value: json['value'] as String,
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$FilterOptionToJson(FilterOption instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'count': instance.count,
    };

FlightSearchMeta _$FlightSearchMetaFromJson(Map<String, dynamic> json) =>
    FlightSearchMeta(
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      searchDate: DateTime.parse(json['searchDate'] as String),
      totalRoutes: (json['totalRoutes'] as num).toInt(),
      availableAirlines: (json['availableAirlines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      priceRange:
          PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlightSearchMetaToJson(FlightSearchMeta instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'searchDate': instance.searchDate.toIso8601String(),
      'totalRoutes': instance.totalRoutes,
      'availableAirlines': instance.availableAirlines,
      'priceRange': instance.priceRange,
    };

PriceRange _$PriceRangeFromJson(Map<String, dynamic> json) => PriceRange(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PriceRangeToJson(PriceRange instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'currency': instance.currency,
    };

DestinationModel _$DestinationModelFromJson(Map<String, dynamic> json) =>
    DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailImage: json['thumbnailImage'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
      popularActivities: (json['popularActivities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      climate: json['climate'] as String,
      bestTimeToVisit: json['bestTimeToVisit'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DestinationModelToJson(DestinationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'region': instance.region,
      'description': instance.description,
      'images': instance.images,
      'thumbnailImage': instance.thumbnailImage,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
      'popularActivities': instance.popularActivities,
      'climate': instance.climate,
      'bestTimeToVisit': instance.bestTimeToVisit,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'tags': instance.tags,
    };

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      destination: json['destination'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailImage: json['thumbnailImage'] as String?,
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instantBooking: json['instantBooking'] as bool,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'destination': instance.destination,
      'price': instance.price,
      'currency': instance.currency,
      'durationMinutes': instance.durationMinutes,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'images': instance.images,
      'thumbnailImage': instance.thumbnailImage,
      'inclusions': instance.inclusions,
      'requirements': instance.requirements,
      'instantBooking': instance.instantBooking,
    };

WeatherInfoResponse _$WeatherInfoResponseFromJson(Map<String, dynamic> json) =>
    WeatherInfoResponse(
      destination: json['destination'] as String,
      date: DateTime.parse(json['date'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      description: json['description'] as String,
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      temperatureUnit: json['temperatureUnit'] as String,
      forecast: (json['forecast'] as List<dynamic>?)
          ?.map((e) => WeatherForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherInfoResponseToJson(
        WeatherInfoResponse instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'date': instance.date.toIso8601String(),
      'temperature': instance.temperature,
      'description': instance.description,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'temperatureUnit': instance.temperatureUnit,
      'forecast': instance.forecast,
    };

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      date: DateTime.parse(json['date'] as String),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      description: json['description'] as String,
      humidity: (json['humidity'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'maxTemp': instance.maxTemp,
      'minTemp': instance.minTemp,
      'description': instance.description,
      'humidity': instance.humidity,
    };

AvailabilityQuery _$AvailabilityQueryFromJson(Map<String, dynamic> json) =>
    AvailabilityQuery(
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      rooms: (json['rooms'] as num).toInt(),
    );

Map<String, dynamic> _$AvailabilityQueryToJson(AvailabilityQuery instance) =>
    <String, dynamic>{
      'checkIn': instance.checkIn.toIso8601String(),
      'checkOut': instance.checkOut.toIso8601String(),
      'adults': instance.adults,
      'children': instance.children,
      'rooms': instance.rooms,
    };

PricingQuery _$PricingQueryFromJson(Map<String, dynamic> json) => PricingQuery(
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      rooms: (json['rooms'] as num).toInt(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$PricingQueryToJson(PricingQuery instance) =>
    <String, dynamic>{
      'checkIn': instance.checkIn.toIso8601String(),
      'checkOut': instance.checkOut.toIso8601String(),
      'adults': instance.adults,
      'children': instance.children,
      'rooms': instance.rooms,
      'currency': instance.currency,
    };

FlightRouteQuery _$FlightRouteQueryFromJson(Map<String, dynamic> json) =>
    FlightRouteQuery(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      seatClass: $enumDecodeNullable(_$SeatClassEnumMap, json['seatClass']),
      passengers: (json['passengers'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FlightRouteQueryToJson(FlightRouteQuery instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'seatClass': _$SeatClassEnumMap[instance.seatClass],
      'passengers': instance.passengers,
      'sortBy': instance.sortBy,
      'limit': instance.limit,
    };

ReviewQuery _$ReviewQueryFromJson(Map<String, dynamic> json) => ReviewQuery(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      minRating: (json['minRating'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );

Map<String, dynamic> _$ReviewQueryToJson(ReviewQuery instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'minRating': instance.minRating,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };

ReviewListResponse _$ReviewListResponseFromJson(Map<String, dynamic> json) =>
    ReviewListResponse(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      stats: ReviewStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewListResponseToJson(ReviewListResponse instance) =>
    <String, dynamic>{
      'reviews': instance.reviews,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'stats': instance.stats,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      rating: (json['rating'] as num).toInt(),
      title: json['title'] as String,
      comment: json['comment'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      helpfulCount: (json['helpfulCount'] as num).toInt(),
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
      'helpfulCount': instance.helpfulCount,
      'isVerified': instance.isVerified,
    };

ReviewStats _$ReviewStatsFromJson(Map<String, dynamic> json) => ReviewStats(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      ratingDistribution:
          (json['ratingDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$ReviewStatsToJson(ReviewStats instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'ratingDistribution':
          instance.ratingDistribution.map((k, e) => MapEntry(k.toString(), e)),
    };

CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) =>
    CreateReviewRequest(
      rating: (json['rating'] as num).toInt(),
      title: json['title'] as String,
      comment: json['comment'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateReviewRequestToJson(
        CreateReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'images': instance.images,
    };

FavoriteListResponse _$FavoriteListResponseFromJson(
        Map<String, dynamic> json) =>
    FavoriteListResponse(
      favorites: (json['favorites'] as List<dynamic>)
          .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$FavoriteListResponseToJson(
        FavoriteListResponse instance) =>
    <String, dynamic>{
      'favorites': instance.favorites,
      'totalCount': instance.totalCount,
    };

FavoriteItem _$FavoriteItemFromJson(Map<String, dynamic> json) => FavoriteItem(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$FavoriteItemToJson(FavoriteItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'currency': instance.currency,
      'addedAt': instance.addedAt.toIso8601String(),
    };

AddFavoriteRequest _$AddFavoriteRequestFromJson(Map<String, dynamic> json) =>
    AddFavoriteRequest(
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
    );

Map<String, dynamic> _$AddFavoriteRequestToJson(AddFavoriteRequest instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemType': instance.itemType,
    };

ComparePackagesRequest _$ComparePackagesRequestFromJson(
        Map<String, dynamic> json) =>
    ComparePackagesRequest(
      packageIds: (json['packageIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ComparePackagesRequestToJson(
        ComparePackagesRequest instance) =>
    <String, dynamic>{
      'packageIds': instance.packageIds,
    };

ComparisonResponse _$ComparisonResponseFromJson(Map<String, dynamic> json) =>
    ComparisonResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => TravelPackageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comparisonMatrix: ComparisonMatrix.fromJson(
          json['comparisonMatrix'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComparisonResponseToJson(ComparisonResponse instance) =>
    <String, dynamic>{
      'packages': instance.packages,
      'comparisonMatrix': instance.comparisonMatrix,
    };

ComparisonMatrix _$ComparisonMatrixFromJson(Map<String, dynamic> json) =>
    ComparisonMatrix(
      features: (json['features'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
    );

Map<String, dynamic> _$ComparisonMatrixToJson(ComparisonMatrix instance) =>
    <String, dynamic>{
      'features': instance.features,
    };

LivePricingQuery _$LivePricingQueryFromJson(Map<String, dynamic> json) =>
    LivePricingQuery(
      travelDate: json['travelDate'] == null
          ? null
          : DateTime.parse(json['travelDate'] as String),
      travelers: (json['travelers'] as num?)?.toInt(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$LivePricingQueryToJson(LivePricingQuery instance) =>
    <String, dynamic>{
      'travelDate': instance.travelDate?.toIso8601String(),
      'travelers': instance.travelers,
      'currency': instance.currency,
    };

LivePricingResponse _$LivePricingResponseFromJson(Map<String, dynamic> json) =>
    LivePricingResponse(
      packageId: json['packageId'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      alerts: (json['alerts'] as List<dynamic>?)
          ?.map((e) => PriceAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      trend: PriceTrend.fromJson(json['trend'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LivePricingResponseToJson(
        LivePricingResponse instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'currentPrice': instance.currentPrice,
      'originalPrice': instance.originalPrice,
      'currency': instance.currency,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'alerts': instance.alerts,
      'trend': instance.trend,
    };

PriceAlert _$PriceAlertFromJson(Map<String, dynamic> json) => PriceAlert(
      type: json['type'] as String,
      message: json['message'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PriceAlertToJson(PriceAlert instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

PriceTrend _$PriceTrendFromJson(Map<String, dynamic> json) => PriceTrend(
      direction: json['direction'] as String,
      changePercent: (json['changePercent'] as num).toDouble(),
      history: (json['history'] as List<dynamic>)
          .map((e) => PricePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PriceTrendToJson(PriceTrend instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'changePercent': instance.changePercent,
      'history': instance.history,
    };

PricePoint _$PricePointFromJson(Map<String, dynamic> json) => PricePoint(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PricePointToJson(PricePoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'price': instance.price,
    };

HotelAvailabilityResponse _$HotelAvailabilityResponseFromJson(
        Map<String, dynamic> json) =>
    HotelAvailabilityResponse(
      hotelId: json['hotelId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      roomAvailability: (json['roomAvailability'] as List<dynamic>)
          .map((e) => RoomAvailability.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$HotelAvailabilityResponseToJson(
        HotelAvailabilityResponse instance) =>
    <String, dynamic>{
      'hotelId': instance.hotelId,
      'checkIn': instance.checkIn.toIso8601String(),
      'checkOut': instance.checkOut.toIso8601String(),
      'roomAvailability': instance.roomAvailability,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

HotelPricingResponse _$HotelPricingResponseFromJson(
        Map<String, dynamic> json) =>
    HotelPricingResponse(
      hotelId: json['hotelId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      roomPricing: (json['roomPricing'] as List<dynamic>)
          .map((e) => RoomPricing.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$HotelPricingResponseToJson(
        HotelPricingResponse instance) =>
    <String, dynamic>{
      'hotelId': instance.hotelId,
      'checkIn': instance.checkIn.toIso8601String(),
      'checkOut': instance.checkOut.toIso8601String(),
      'roomPricing': instance.roomPricing,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

RoomAvailability _$RoomAvailabilityFromJson(Map<String, dynamic> json) =>
    RoomAvailability(
      roomTypeId: json['roomTypeId'] as String,
      roomTypeName: json['roomTypeName'] as String,
      availableRooms: (json['availableRooms'] as num).toInt(),
      totalRooms: (json['totalRooms'] as num).toInt(),
    );

Map<String, dynamic> _$RoomAvailabilityToJson(RoomAvailability instance) =>
    <String, dynamic>{
      'roomTypeId': instance.roomTypeId,
      'roomTypeName': instance.roomTypeName,
      'availableRooms': instance.availableRooms,
      'totalRooms': instance.totalRooms,
    };

RoomPricing _$RoomPricingFromJson(Map<String, dynamic> json) => RoomPricing(
      roomTypeId: json['roomTypeId'] as String,
      roomTypeName: json['roomTypeName'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      currency: json['currency'] as String,
      breakdown: (json['breakdown'] as List<dynamic>?)
          ?.map((e) => PriceBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomPricingToJson(RoomPricing instance) =>
    <String, dynamic>{
      'roomTypeId': instance.roomTypeId,
      'roomTypeName': instance.roomTypeName,
      'totalPrice': instance.totalPrice,
      'pricePerNight': instance.pricePerNight,
      'currency': instance.currency,
      'breakdown': instance.breakdown,
    };

PriceBreakdown _$PriceBreakdownFromJson(Map<String, dynamic> json) =>
    PriceBreakdown(
      itemType: json['itemType'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PriceBreakdownToJson(PriceBreakdown instance) =>
    <String, dynamic>{
      'itemType': instance.itemType,
      'description': instance.description,
      'amount': instance.amount,
      'quantity': instance.quantity,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _TravelService implements TravelService {
  _TravelService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<PackageSearchResponse> searchPackages(PackageSearchQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PackageSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PackageSearchResponse _value;
    try {
      _value = PackageSearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TravelPackageModel> getPackage(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TravelPackageModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TravelPackageModel _value;
    try {
      _value = TravelPackageModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TravelPackageModel>> getSimilarPackages(
    String id,
    int limit,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TravelPackageModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/${id}/similar',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TravelPackageModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              TravelPackageModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TravelPackageModel>> getPopularPackages(int? limit) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TravelPackageModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/popular',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TravelPackageModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              TravelPackageModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TravelPackageModel>> getFeaturedPackages(int? limit) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TravelPackageModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/featured',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TravelPackageModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              TravelPackageModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TravelPackageModel>> getLastMinuteDeals(int? limit) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TravelPackageModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/last-minute-deals',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TravelPackageModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              TravelPackageModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<HotelSearchResponse> searchHotels(HotelSearchQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HotelSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/hotels',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HotelSearchResponse _value;
    try {
      _value = HotelSearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<HotelModel> getHotel(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HotelModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/hotels/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HotelModel _value;
    try {
      _value = HotelModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<HotelAvailabilityResponse> getHotelAvailability(
    String id,
    AvailabilityQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HotelAvailabilityResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/hotels/${id}/availability',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HotelAvailabilityResponse _value;
    try {
      _value = HotelAvailabilityResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<HotelPricingResponse> getHotelPricing(
    String id,
    PricingQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HotelPricingResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/hotels/${id}/pricing',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HotelPricingResponse _value;
    try {
      _value = HotelPricingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FlightSearchResponse> searchFlights(FlightSearchQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<FlightSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/flights',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FlightSearchResponse _value;
    try {
      _value = FlightSearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FlightModel> getFlight(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<FlightModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/flights/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FlightModel _value;
    try {
      _value = FlightModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<FlightModel>> getFlightsByRoute(
    String origin,
    String destination,
    FlightRouteQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<FlightModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/flights/routes/${origin}/${destination}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<FlightModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => FlightModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DestinationSearchResponse> searchDestinations(
      DestinationSearchQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DestinationSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/destinations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DestinationSearchResponse _value;
    try {
      _value = DestinationSearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DestinationModel> getDestination(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DestinationModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/destinations/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DestinationModel _value;
    try {
      _value = DestinationModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DestinationModel>> getTrendingDestinations(int? limit) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<DestinationModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/destinations/trending',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DestinationModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              DestinationModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<WeatherInfoResponse> getDestinationWeather(
    String id,
    String? date,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'date': date};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<WeatherInfoResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/destinations/${id}/weather',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late WeatherInfoResponse _value;
    try {
      _value = WeatherInfoResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ActivitySearchResponse> searchActivities(
      ActivitySearchQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ActivitySearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/activities',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ActivitySearchResponse _value;
    try {
      _value = ActivitySearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ActivityModel> getActivity(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ActivityModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/activities/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ActivityModel _value;
    try {
      _value = ActivityModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewListResponse> getPackageReviews(
    String id,
    ReviewQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ReviewListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/${id}/reviews',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewListResponse _value;
    try {
      _value = ReviewListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewModel> createPackageReview(
    String token,
    String id,
    CreateReviewRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ReviewModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/${id}/reviews',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewModel _value;
    try {
      _value = ReviewModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewListResponse> getHotelReviews(
    String id,
    ReviewQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ReviewListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/hotels/${id}/reviews',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewListResponse _value;
    try {
      _value = ReviewListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FavoriteListResponse> getFavorites(
    String token,
    String? type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'type': type};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<FavoriteListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/favorites',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FavoriteListResponse _value;
    try {
      _value = FavoriteListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> addToFavorites(
    String token,
    AddFavoriteRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/favorites',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> removeFromFavorites(
    String token,
    String itemId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/favorites/${itemId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<ComparisonResponse> comparePackages(
      ComparePackagesRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ComparisonResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/compare',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ComparisonResponse _value;
    try {
      _value = ComparisonResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<LivePricingResponse> getLivePricing(
    String id,
    LivePricingQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<LivePricingResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/packages/${id}/live-pricing',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LivePricingResponse _value;
    try {
      _value = LivePricingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
