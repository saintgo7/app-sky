import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../core/environment/env_config.dart';

class GoogleMapService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';

  // Directions API - 경로 검색 (Google Directions API)
  static Future<GoogleDirectionsResult?> getDirections({
    required gmaps.LatLng origin,
    required gmaps.LatLng destination,
    String mode = 'driving', // driving, walking, bicycling, transit
    List<gmaps.LatLng>? waypoints,
    String? avoid, // tolls, highways, ferries
    String? units, // metric, imperial
  }) async {
    try {
      final params = {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': mode,
        'key': EnvConfig.googleMapsApiKey,
        if (waypoints != null && waypoints.isNotEmpty)
          'waypoints': waypoints.map((wp) => '${wp.latitude},${wp.longitude}').join('|'),
        if (avoid != null) 'avoid': avoid,
        if (units != null) 'units': units,
      };

      final url = Uri.parse('$_baseUrl/directions/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GoogleDirectionsResult.fromJson(data);
      }
    } catch (e) {
      print('Google Directions error: $e');
    }
    return null;
  }

  // Places API - 장소 검색
  static Future<List<GooglePlace>> searchPlaces({
    required String query,
    gmaps.LatLng? location,
    int radius = 5000,
    String? type, // restaurant, hotel, etc.
    String? language = 'ko',
  }) async {
    try {
      final params = {
        'query': query,
        'key': EnvConfig.googleMapsApiKey,
        if (language != null) 'language': language,
      };

      // Text Search API 사용
      final url = Uri.parse('$_baseUrl/place/textsearch/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        if (results != null) {
          return results.map((place) => GooglePlace.fromJson(place)).toList();
        }
      }
    } catch (e) {
      print('Google Places search error: $e');
    }
    return [];
  }

  // Nearby Search - 주변 검색
  static Future<List<GooglePlace>> searchNearby({
    required gmaps.LatLng location,
    int radius = 5000,
    String? type, // restaurant, hotel, etc.
    String? keyword,
    int? minPrice,
    int? maxPrice,
    String? language = 'ko',
  }) async {
    try {
      final params = {
        'location': '${location.latitude},${location.longitude}',
        'radius': radius.toString(),
        'key': EnvConfig.googleMapsApiKey,
        if (type != null) 'type': type,
        if (keyword != null) 'keyword': keyword,
        if (minPrice != null) 'minprice': minPrice.toString(),
        if (maxPrice != null) 'maxprice': maxPrice.toString(),
        if (language != null) 'language': language,
      };

      final url = Uri.parse('$_baseUrl/place/nearbysearch/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        if (results != null) {
          return results.map((place) => GooglePlace.fromJson(place)).toList();
        }
      }
    } catch (e) {
      print('Google Nearby search error: $e');
    }
    return [];
  }

  // Place Details - 장소 상세 정보
  static Future<GooglePlaceDetail?> getPlaceDetails({
    required String placeId,
    String? language = 'ko',
    List<String>? fields,
  }) async {
    try {
      final params = {
        'place_id': placeId,
        'key': EnvConfig.googleMapsApiKey,
        if (language != null) 'language': language,
        if (fields != null) 'fields': fields.join(','),
      };

      final url = Uri.parse('$_baseUrl/place/details/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GooglePlaceDetail.fromJson(data['result']);
      }
    } catch (e) {
      print('Google Place details error: $e');
    }
    return null;
  }

  // Geocoding - 주소로 좌표 찾기
  static Future<List<GoogleGeocodeResult>> geocode({
    required String address,
    String? region,
    String? language = 'ko',
  }) async {
    try {
      final params = {
        'address': address,
        'key': EnvConfig.googleMapsApiKey,
        if (region != null) 'region': region,
        if (language != null) 'language': language,
      };

      final url = Uri.parse('$_baseUrl/geocode/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        if (results != null) {
          return results.map((result) => GoogleGeocodeResult.fromJson(result)).toList();
        }
      }
    } catch (e) {
      print('Google Geocoding error: $e');
    }
    return [];
  }

  // Reverse Geocoding - 좌표로 주소 찾기
  static Future<List<GoogleGeocodeResult>> reverseGeocode({
    required gmaps.LatLng location,
    String? language = 'ko',
    String? resultType, // country, administrative_area_level_1, etc.
  }) async {
    try {
      final params = {
        'latlng': '${location.latitude},${location.longitude}',
        'key': EnvConfig.googleMapsApiKey,
        if (language != null) 'language': language,
        if (resultType != null) 'result_type': resultType,
      };

      final url = Uri.parse('$_baseUrl/geocode/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        if (results != null) {
          return results.map((result) => GoogleGeocodeResult.fromJson(result)).toList();
        }
      }
    } catch (e) {
      print('Google Reverse geocoding error: $e');
    }
    return [];
  }

  // Distance Matrix - 거리 및 시간 계산
  static Future<GoogleDistanceMatrix?> getDistanceMatrix({
    required List<gmaps.LatLng> origins,
    required List<gmaps.LatLng> destinations,
    String mode = 'driving',
    String? units = 'metric',
    String? avoid,
  }) async {
    try {
      final params = {
        'origins': origins.map((loc) => '${loc.latitude},${loc.longitude}').join('|'),
        'destinations': destinations.map((loc) => '${loc.latitude},${loc.longitude}').join('|'),
        'mode': mode,
        'key': EnvConfig.googleMapsApiKey,
        if (units != null) 'units': units,
        if (avoid != null) 'avoid': avoid,
      };

      final url = Uri.parse('$_baseUrl/distancematrix/json').replace(queryParameters: params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GoogleDistanceMatrix.fromJson(data);
      }
    } catch (e) {
      print('Google Distance Matrix error: $e');
    }
    return null;
  }

  // Static Maps API - 정적 지도 이미지
  static String getStaticMapUrl({
    required gmaps.LatLng center,
    int zoom = 15,
    int width = 400,
    int height = 400,
    String? mapType, // roadmap, satellite, hybrid, terrain
    List<GooglePlace>? markers,
    List<gmaps.LatLng>? path,
  }) {
    final params = {
      'center': '${center.latitude},${center.longitude}',
      'zoom': zoom.toString(),
      'size': '${width}x$height',
      'key': EnvConfig.googleMapsApiKey,
      if (mapType != null) 'maptype': mapType,
      if (markers != null && markers.isNotEmpty)
        'markers': markers.map((marker) =>
          'color:red|label:${marker.name?.substring(0, 1) ?? 'P'}|${marker.geometry?.location?.lat ?? 0},${marker.geometry?.location?.lng ?? 0}'
        ).join('&markers='),
      if (path != null && path.isNotEmpty)
        'path': 'color:0x0000ff|weight:5|${path.map((point) => '${point.latitude},${point.longitude}').join('|')}',
    };

    final url = Uri.parse('$_baseUrl/staticmap').replace(queryParameters: params);
    return url.toString();
  }

  // Calculate distance between two points (Haversine formula)
  static double calculateDistance(
    gmaps.LatLng point1,
    gmaps.LatLng point2,
  ) {
    const double earthRadius = 6371000; // meters

    final double lat1Rad = point1.latitude * (3.141592653589793 / 180);
    final double lat2Rad = point2.latitude * (3.141592653589793 / 180);
    final double deltaLatRad = (point2.latitude - point1.latitude) * (3.141592653589793 / 180);
    final double deltaLngRad = (point2.longitude - point1.longitude) * (3.141592653589793 / 180);

    final double a = (deltaLatRad / 2).sin() * (deltaLatRad / 2).sin() +
        lat1Rad.cos() * lat2Rad.cos() *
        (deltaLngRad / 2).sin() * (deltaLngRad / 2).sin();

    final double c = 2 * a.atan2(a.sqrt(), (1 - a).sqrt());

    return earthRadius * c;
  }
}

// Google Directions Result
class GoogleDirectionsResult {
  final List<GoogleRoute> routes;
  final String status;

  GoogleDirectionsResult({
    required this.routes,
    required this.status,
  });

  factory GoogleDirectionsResult.fromJson(Map<String, dynamic> json) {
    return GoogleDirectionsResult(
      routes: (json['routes'] as List).map((route) => GoogleRoute.fromJson(route)).toList(),
      status: json['status'],
    );
  }
}

class GoogleRoute {
  final GoogleRouteLeg leg;
  final String summary;
  final List<gmaps.LatLng> polylinePoints;

  GoogleRoute({
    required this.leg,
    required this.summary,
    required this.polylinePoints,
  });

  factory GoogleRoute.fromJson(Map<String, dynamic> json) {
    final legs = json['legs'] as List;
    final leg = GoogleRouteLeg.fromJson(legs[0]);

    // Decode polyline
    final points = json['overview_polyline']['points'] as String;
    final polylinePoints = _decodePolyline(points);

    return GoogleRoute(
      leg: leg,
      summary: json['summary'] ?? '',
      polylinePoints: polylinePoints,
    );
  }

  static List<gmaps.LatLng> _decodePolyline(String encoded) {
    List<gmaps.LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(gmaps.LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}

class GoogleRouteLeg {
  final GoogleDistance distance;
  final GoogleDuration duration;
  final String startAddress;
  final String endAddress;
  final gmaps.LatLng startLocation;
  final gmaps.LatLng endLocation;
  final List<GoogleRouteStep> steps;

  GoogleRouteLeg({
    required this.distance,
    required this.duration,
    required this.startAddress,
    required this.endAddress,
    required this.startLocation,
    required this.endLocation,
    required this.steps,
  });

  factory GoogleRouteLeg.fromJson(Map<String, dynamic> json) {
    return GoogleRouteLeg(
      distance: GoogleDistance.fromJson(json['distance']),
      duration: GoogleDuration.fromJson(json['duration']),
      startAddress: json['start_address'],
      endAddress: json['end_address'],
      startLocation: gmaps.LatLng(
        json['start_location']['lat'],
        json['start_location']['lng'],
      ),
      endLocation: gmaps.LatLng(
        json['end_location']['lat'],
        json['end_location']['lng'],
      ),
      steps: (json['steps'] as List).map((step) => GoogleRouteStep.fromJson(step)).toList(),
    );
  }
}

class GoogleDistance {
  final int value; // meters
  final String text;

  GoogleDistance({required this.value, required this.text});

  factory GoogleDistance.fromJson(Map<String, dynamic> json) {
    return GoogleDistance(
      value: json['value'],
      text: json['text'],
    );
  }
}

class GoogleDuration {
  final int value; // seconds
  final String text;

  GoogleDuration({required this.value, required this.text});

  factory GoogleDuration.fromJson(Map<String, dynamic> json) {
    return GoogleDuration(
      value: json['value'],
      text: json['text'],
    );
  }
}

class GoogleRouteStep {
  final GoogleDistance distance;
  final GoogleDuration duration;
  final gmaps.LatLng startLocation;
  final gmaps.LatLng endLocation;
  final String instructions;
  final String travelMode;

  GoogleRouteStep({
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.instructions,
    required this.travelMode,
  });

  factory GoogleRouteStep.fromJson(Map<String, dynamic> json) {
    return GoogleRouteStep(
      distance: GoogleDistance.fromJson(json['distance']),
      duration: GoogleDuration.fromJson(json['duration']),
      startLocation: gmaps.LatLng(
        json['start_location']['lat'],
        json['start_location']['lng'],
      ),
      endLocation: gmaps.LatLng(
        json['end_location']['lat'],
        json['end_location']['lng'],
      ),
      instructions: json['html_instructions'] ?? '',
      travelMode: json['travel_mode'],
    );
  }
}

// Google Place
class GooglePlace {
  final String placeId;
  final String name;
  final String? address;
  final double rating;
  final int userRatingsTotal;
  final GoogleGeometry geometry;
  final List<String> types;
  final GooglePlacePhoto? photo;
  final bool openNow;
  final GooglePriceLevel? priceLevel;

  GooglePlace({
    required this.placeId,
    required this.name,
    this.address,
    required this.rating,
    required this.userRatingsTotal,
    required this.geometry,
    required this.types,
    this.photo,
    required this.openNow,
    this.priceLevel,
  });

  factory GooglePlace.fromJson(Map<String, dynamic> json) {
    return GooglePlace(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['formatted_address'] ?? json['vicinity'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      geometry: GoogleGeometry.fromJson(json['geometry']),
      types: List<String>.from(json['types'] ?? []),
      photo: json['photos'] != null ? GooglePlacePhoto.fromJson(json['photos'][0]) : null,
      openNow: json['opening_hours']?['open_now'] ?? false,
      priceLevel: json['price_level'] != null ? GooglePriceLevel.values[json['price_level']] : null,
    );
  }
}

class GoogleGeometry {
  final gmaps.LatLng location;
  final GoogleBounds? viewport;

  GoogleGeometry({
    required this.location,
    this.viewport,
  });

  factory GoogleGeometry.fromJson(Map<String, dynamic> json) {
    return GoogleGeometry(
      location: gmaps.LatLng(
        json['location']['lat'],
        json['location']['lng'],
      ),
      viewport: json['viewport'] != null ? GoogleBounds.fromJson(json['viewport']) : null,
    );
  }
}

class GoogleBounds {
  final gmaps.LatLng northeast;
  final gmaps.LatLng southwest;

  GoogleBounds({
    required this.northeast,
    required this.southwest,
  });

  factory GoogleBounds.fromJson(Map<String, dynamic> json) {
    return GoogleBounds(
      northeast: gmaps.LatLng(
        json['northeast']['lat'],
        json['northeast']['lng'],
      ),
      southwest: gmaps.LatLng(
        json['southwest']['lat'],
        json['southwest']['lng'],
      ),
    );
  }
}

class GooglePlacePhoto {
  final String photoReference;
  final int width;
  final int height;

  GooglePlacePhoto({
    required this.photoReference,
    required this.width,
    required this.height,
  });

  factory GooglePlacePhoto.fromJson(Map<String, dynamic> json) {
    return GooglePlacePhoto(
      photoReference: json['photo_reference'],
      width: json['width'],
      height: json['height'],
    );
  }

  String getPhotoUrl({int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=${EnvConfig.googleMapsApiKey}';
  }
}

enum GooglePriceLevel {
  free,
  inexpensive,
  moderate,
  expensive,
  veryExpensive,
}

// Google Place Detail
class GooglePlaceDetail {
  final String placeId;
  final String name;
  final String? formattedAddress;
  final String? formattedPhoneNumber;
  final String? website;
  final double rating;
  final int userRatingsTotal;
  final GoogleGeometry geometry;
  final List<GooglePlaceReview> reviews;
  final List<String> types;
  final GoogleOpeningHours? openingHours;
  final GooglePriceLevel? priceLevel;
  final List<GooglePlacePhoto> photos;

  GooglePlaceDetail({
    required this.placeId,
    required this.name,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.website,
    required this.rating,
    required this.userRatingsTotal,
    required this.geometry,
    required this.reviews,
    required this.types,
    this.openingHours,
    this.priceLevel,
    required this.photos,
  });

  factory GooglePlaceDetail.fromJson(Map<String, dynamic> json) {
    return GooglePlaceDetail(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'],
      formattedPhoneNumber: json['formatted_phone_number'],
      website: json['website'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      geometry: GoogleGeometry.fromJson(json['geometry']),
      reviews: (json['reviews'] as List?)?.map((review) => GooglePlaceReview.fromJson(review)).toList() ?? [],
      types: List<String>.from(json['types'] ?? []),
      openingHours: json['opening_hours'] != null ? GoogleOpeningHours.fromJson(json['opening_hours']) : null,
      priceLevel: json['price_level'] != null ? GooglePriceLevel.values[json['price_level']] : null,
      photos: (json['photos'] as List?)?.map((photo) => GooglePlacePhoto.fromJson(photo)).toList() ?? [],
    );
  }
}

class GooglePlaceReview {
  final String authorName;
  final double rating;
  final String text;
  final int time;
  final String? authorPhotoUrl;

  GooglePlaceReview({
    required this.authorName,
    required this.rating,
    required this.text,
    required this.time,
    this.authorPhotoUrl,
  });

  factory GooglePlaceReview.fromJson(Map<String, dynamic> json) {
    return GooglePlaceReview(
      authorName: json['author_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      text: json['text'] ?? '',
      time: json['time'] ?? 0,
      authorPhotoUrl: json['profile_photo_url'],
    );
  }
}

class GoogleOpeningHours {
  final bool openNow;
  final List<GoogleOpeningPeriod> periods;
  final List<String> weekdayText;

  GoogleOpeningHours({
    required this.openNow,
    required this.periods,
    required this.weekdayText,
  });

  factory GoogleOpeningHours.fromJson(Map<String, dynamic> json) {
    return GoogleOpeningHours(
      openNow: json['open_now'] ?? false,
      periods: (json['periods'] as List?)?.map((period) => GoogleOpeningPeriod.fromJson(period)).toList() ?? [],
      weekdayText: List<String>.from(json['weekday_text'] ?? []),
    );
  }
}

class GoogleOpeningPeriod {
  final GoogleOpeningTime open;
  final GoogleOpeningTime? close;

  GoogleOpeningPeriod({
    required this.open,
    this.close,
  });

  factory GoogleOpeningPeriod.fromJson(Map<String, dynamic> json) {
    return GoogleOpeningPeriod(
      open: GoogleOpeningTime.fromJson(json['open']),
      close: json['close'] != null ? GoogleOpeningTime.fromJson(json['close']) : null,
    );
  }
}

class GoogleOpeningTime {
  final int day;
  final String time;

  GoogleOpeningTime({
    required this.day,
    required this.time,
  });

  factory GoogleOpeningTime.fromJson(Map<String, dynamic> json) {
    return GoogleOpeningTime(
      day: json['day'] ?? 0,
      time: json['time'] ?? '',
    );
  }
}

// Google Geocode Result
class GoogleGeocodeResult {
  final String formattedAddress;
  final GoogleGeometry geometry;
  final List<GoogleAddressComponent> addressComponents;
  final String placeId;

  GoogleGeocodeResult({
    required this.formattedAddress,
    required this.geometry,
    required this.addressComponents,
    required this.placeId,
  });

  factory GoogleGeocodeResult.fromJson(Map<String, dynamic> json) {
    return GoogleGeocodeResult(
      formattedAddress: json['formatted_address'] ?? '',
      geometry: GoogleGeometry.fromJson(json['geometry']),
      addressComponents: (json['address_components'] as List)
          .map((comp) => GoogleAddressComponent.fromJson(comp))
          .toList(),
      placeId: json['place_id'] ?? '',
    );
  }
}

class GoogleAddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  GoogleAddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory GoogleAddressComponent.fromJson(Map<String, dynamic> json) {
    return GoogleAddressComponent(
      longName: json['long_name'] ?? '',
      shortName: json['short_name'] ?? '',
      types: List<String>.from(json['types'] ?? []),
    );
  }
}

// Google Distance Matrix
class GoogleDistanceMatrix {
  final List<GoogleDistanceMatrixRow> rows;
  final String status;

  GoogleDistanceMatrix({
    required this.rows,
    required this.status,
  });

  factory GoogleDistanceMatrix.fromJson(Map<String, dynamic> json) {
    return GoogleDistanceMatrix(
      rows: (json['rows'] as List).map((row) => GoogleDistanceMatrixRow.fromJson(row)).toList(),
      status: json['status'],
    );
  }
}

class GoogleDistanceMatrixRow {
  final List<GoogleDistanceMatrixElement> elements;

  GoogleDistanceMatrixRow({required this.elements});

  factory GoogleDistanceMatrixRow.fromJson(Map<String, dynamic> json) {
    return GoogleDistanceMatrixRow(
      elements: (json['elements'] as List)
          .map((element) => GoogleDistanceMatrixElement.fromJson(element))
          .toList(),
    );
  }
}

class GoogleDistanceMatrixElement {
  final GoogleDistance? distance;
  final GoogleDuration? duration;
  final String status;

  GoogleDistanceMatrixElement({
    this.distance,
    this.duration,
    required this.status,
  });

  factory GoogleDistanceMatrixElement.fromJson(Map<String, dynamic> json) {
    return GoogleDistanceMatrixElement(
      distance: json['distance'] != null ? GoogleDistance.fromJson(json['distance']) : null,
      duration: json['duration'] != null ? GoogleDuration.fromJson(json['duration']) : null,
      status: json['status'],
    );
  }
}
