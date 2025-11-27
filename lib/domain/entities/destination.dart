class Destination {
  final String id;
  final String name;
  final String country;
  final String city;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String currency;
  final String language;
  final List<String> attractions;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic> metadata;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.currency,
    required this.language,
    this.attractions = const [],
    this.categories = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.metadata = const {},
  });

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? city,
    String? description,
    List<String>? images,
    double? latitude,
    double? longitude,
    String? currency,
    String? language,
    List<String>? attractions,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? metadata,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      city: city ?? this.city,
      description: description ?? this.description,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      attractions: attractions ?? this.attractions,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      metadata: metadata ?? this.metadata,
    );
  }
}

class DestinationCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  const DestinationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Attraction {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;
  final AttractionType type;
  final double rating;
  final String priceRange;
  final Map<String, dynamic> operatingHours;

  const Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.rating = 0.0,
    this.priceRange = '',
    this.operatingHours = const {},
  });
}

enum AttractionType {
  historical,
  natural,
  cultural,
  entertainment,
  shopping,
  food,
  adventure,
  religious,
}
