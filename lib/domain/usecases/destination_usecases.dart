import 'package:dartz/dartz.dart';

import '../entities/destination.dart';
import 'base_usecase.dart';

class SearchDestinationsParams {
  final String query;
  final List<String>? categories;
  final double? minRating;
  final String? country;
  final String? city;
  final int limit;
  final int offset;

  const SearchDestinationsParams({
    required this.query,
    this.categories,
    this.minRating,
    this.country,
    this.city,
    this.limit = 20,
    this.offset = 0,
  });
}

class GetDestinationDetailsParams {
  final String destinationId;
  final bool includeAttractions;

  const GetDestinationDetailsParams({
    required this.destinationId,
    this.includeAttractions = true,
  });
}

class GetPopularDestinationsParams {
  final String? category;
  final int limit;

  const GetPopularDestinationsParams({
    this.category,
    this.limit = 10,
  });
}

class GetNearbyDestinationsParams {
  final double latitude;
  final double longitude;
  final double radius; // in kilometers
  final int limit;

  const GetNearbyDestinationsParams({
    required this.latitude,
    required this.longitude,
    this.radius = 50.0,
    this.limit = 20,
  });
}

abstract class SearchDestinationsUseCase implements UseCase<List<Destination>, SearchDestinationsParams> {}

abstract class GetDestinationDetailsUseCase implements UseCase<Destination, GetDestinationDetailsParams> {}

abstract class GetPopularDestinationsUseCase implements UseCase<List<Destination>, GetPopularDestinationsParams> {}

abstract class GetNearbyDestinationsUseCase implements UseCase<List<Destination>, GetNearbyDestinationsParams> {}

abstract class GetDestinationCategoriesUseCase implements UseCase<List<DestinationCategory>, NoParams> {}
