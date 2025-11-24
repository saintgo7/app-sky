class Hotel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final HotelRating rating;
  final double starRating;
  final int reviewCount;
  final List<String> amenities;
  final List<String> policies;
  final Map<String, RoomType> roomTypes;
  final ContactInfo contactInfo;
  final HotelChain? chain;
  final List<String> nearbyAttractions;
  final double distanceFromCenter;
  final Map<String, dynamic> metadata;

  const Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.rating,
    required this.starRating,
    required this.reviewCount,
    this.amenities = const [],
    this.policies = const [],
    this.roomTypes = const {},
    required this.contactInfo,
    this.chain,
    this.nearbyAttractions = const [],
    this.distanceFromCenter = 0.0,
    this.metadata = const {},
  });

  Hotel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    HotelRating? rating,
    double? starRating,
    int? reviewCount,
    List<String>? amenities,
    List<String>? policies,
    Map<String, RoomType>? roomTypes,
    ContactInfo? contactInfo,
    HotelChain? chain,
    List<String>? nearbyAttractions,
    double? distanceFromCenter,
    Map<String, dynamic>? metadata,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      rating: rating ?? this.rating,
      starRating: starRating ?? this.starRating,
      reviewCount: reviewCount ?? this.reviewCount,
      amenities: amenities ?? this.amenities,
      policies: policies ?? this.policies,
      roomTypes: roomTypes ?? this.roomTypes,
      contactInfo: contactInfo ?? this.contactInfo,
      chain: chain ?? this.chain,
      nearbyAttractions: nearbyAttractions ?? this.nearbyAttractions,
      distanceFromCenter: distanceFromCenter ?? this.distanceFromCenter,
      metadata: metadata ?? this.metadata,
    );
  }
}

class RoomType {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final int maxOccupancy;
  final int bedCount;
  final String bedType;
  final double size; // in square meters
  final List<String> amenities;
  final Map<String, double> pricing; // date -> price
  final int availableRooms;
  final bool isRefundable;
  final String cancellationPolicy;

  const RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.maxOccupancy,
    required this.bedCount,
    required this.bedType,
    required this.size,
    this.amenities = const [],
    this.pricing = const {},
    this.availableRooms = 0,
    this.isRefundable = true,
    this.cancellationPolicy = '',
  });

  double getAveragePrice() {
    if (pricing.isEmpty) return 0.0;
    final total = pricing.values.reduce((a, b) => a + b);
    return total / pricing.length;
  }

  double getLowestPrice() {
    if (pricing.isEmpty) return 0.0;
    return pricing.values.reduce((a, b) => a < b ? a : b);
  }
}

class HotelChain {
  final String id;
  final String name;
  final String logoUrl;
  final String website;
  final String country;

  const HotelChain({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.website,
    required this.country,
  });
}

class ContactInfo {
  final String phone;
  final String email;
  final String website;
  final String? fax;

  const ContactInfo({
    required this.phone,
    required this.email,
    required this.website,
    this.fax,
  });
}

enum HotelRating {
  budget,
  midRange,
  upscale,
  luxury,
  boutique,
}
