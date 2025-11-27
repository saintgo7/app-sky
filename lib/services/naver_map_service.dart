import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/environment/env_config.dart';
import '../domain/entities/destination.dart';

class NaverMapService {
  static const String _baseUrl = 'https://naveropenapi.apigw.ntruss.com';

  // Reverse Geocoding - 좌표로 주소 찾기
  static Future<GeocodingResult?> reverseGeocode(double latitude, double longitude) async {
    try {
      final url = Uri.parse('$_baseUrl/map-reversegeocode/v2/gc')
          .replace(queryParameters: {
            'coords': '$longitude,$latitude',
            'output': 'json',
            'orders': 'legalcode,admcode,addr,roadaddr',
          });

      final response = await http.get(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': EnvConfig.naverMapClientId,
          'X-NCP-APIGW-API-KEY': EnvConfig.naverMapClientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GeocodingResult.fromJson(data);
      }
    } catch (e) {
      print('Reverse geocoding error: $e');
    }
    return null;
  }

  // Geocoding - 주소로 좌표 찾기
  static Future<List<GeocodingResult>> geocode(String address) async {
    try {
      final url = Uri.parse('$_baseUrl/map-geocode/v2/geocode')
          .replace(queryParameters: {
            'query': address,
            'count': '5',
          });

      final response = await http.get(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': EnvConfig.naverMapClientId,
          'X-NCP-APIGW-API-KEY': EnvConfig.naverMapClientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addresses = data['addresses'] as List?;
        if (addresses != null) {
          return addresses
              .map((addr) => GeocodingResult.fromAddressJson(addr))
              .toList();
        }
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
    return [];
  }

  // Directions - 경로 검색
  static Future<DirectionsResult?> getDirections({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String option = 'trafast', // trafast, tracomfort, traoptimal, traavoidtoll, traavoidcaronly
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/map-direction/v1/driving')
          .replace(queryParameters: {
            'start': '$startLng,$startLat',
            'goal': '$endLng,$endLat',
            'option': option,
          });

      final response = await http.get(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': EnvConfig.naverMapClientId,
          'X-NCP-APIGW-API-KEY': EnvConfig.naverMapClientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DirectionsResult.fromJson(data);
      }
    } catch (e) {
      print('Directions error: $e');
    }
    return null;
  }

  // Search - 장소 검색
  static Future<List<SearchResult>> searchPlaces({
    required String query,
    double? latitude,
    double? longitude,
    int radius = 5000, // meters
    String sort = 'random', // random, comment
    int displayCount = 10,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'display': displayCount.toString(),
        'sort': sort,
      };

      if (latitude != null && longitude != null) {
        queryParams['coordinate'] = '$longitude,$latitude';
        queryParams['radius'] = radius.toString();
      }

      final url = Uri.parse('$_baseUrl/map-place/v1/search')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': EnvConfig.naverMapClientId,
          'X-NCP-APIGW-API-KEY': EnvConfig.naverMapClientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final places = data['places'] as List?;
        if (places != null) {
          return places.map((place) => SearchResult.fromJson(place)).toList();
        }
      }
    } catch (e) {
      print('Search places error: $e');
    }
    return [];
  }

  // Calculate distance between two points
  static double calculateDistance(
    double lat1, double lng1,
    double lat2, double lng2,
  ) {
    const double earthRadius = 6371000; // meters

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a = (dLat / 2).sin() * (dLat / 2).sin() +
        _degreesToRadians(lat1).cos() * _degreesToRadians(lat2).cos() *
        (dLng / 2).sin() * (dLng / 2).sin();

    final double c = 2 * a.atan2(a.sqrt(), (1 - a).sqrt());

    return earthRadius * c;
  }

  // Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }
}

// Geocoding Result
class GeocodingResult {
  final String address;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String country;
  final String region;
  final String land;

  GeocodingResult({
    required this.address,
    required this.roadAddress,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.region,
    required this.land,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List?;
    if (results != null && results.isNotEmpty) {
      final result = results[0];
      final region = result['region'] as Map<String, dynamic>;
      final land = result['land'] as Map<String, dynamic>;

      return GeocodingResult(
        address: result['region']['area1']['name'] +
                 ' ' + result['region']['area2']['name'] +
                 ' ' + result['region']['area3']['name'],
        roadAddress: result['land']['name'] ?? '',
        latitude: double.parse(result['code']['id'].toString().substring(0, 8)) / 100000,
        longitude: double.parse(result['code']['id'].toString().substring(8)) / 100000,
        country: region['area0']['name'] ?? '',
        region: region['area1']['name'] ?? '',
        land: land['name'] ?? '',
      );
    }
    throw Exception('No geocoding results found');
  }

  factory GeocodingResult.fromAddressJson(Map<String, dynamic> json) {
    return GeocodingResult(
      address: json['jibunAddress'] ?? json['roadAddress'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      latitude: double.parse(json['y']),
      longitude: double.parse(json['x']),
      country: '대한민국',
      region: json['addressElements']?[0]?['longName'] ?? '',
      land: json['addressElements']?[1]?['longName'] ?? '',
    );
  }
}

// Directions Result
class DirectionsResult {
  final List<Route> routes;
  final int totalDistance; // meters
  final int totalTime; // seconds

  DirectionsResult({
    required this.routes,
    required this.totalDistance,
    required this.totalTime,
  });

  factory DirectionsResult.fromJson(Map<String, dynamic> json) {
    final route = json['route'] as Map<String, dynamic>?;
    if (route != null && route['traoptimal'] != null) {
      final traoptimal = route['traoptimal'] as List;
      final summary = json['route']['traoptimal'][0]['summary'] as Map<String, dynamic>;

      return DirectionsResult(
        routes: traoptimal.map((r) => Route.fromJson(r)).toList(),
        totalDistance: summary['distance'] ?? 0,
        totalTime: summary['duration'] ?? 0,
      );
    }
    throw Exception('No directions found');
  }
}

class Route {
  final List<LatLng> path;
  final List<String> instructions;
  final int distance;
  final int duration;

  Route({
    required this.path,
    required this.instructions,
    required this.distance,
    required this.duration,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    final path = json['path'] as List?;
    final guide = json['guide'] as List?;

    return Route(
      path: path?.map((point) => LatLng(
        latitude: point[1],
        longitude: point[0],
      )).toList() ?? [],
      instructions: guide?.map((g) => g['instructions'] as String).toList() ?? [],
      distance: json['summary']['distance'] ?? 0,
      duration: json['summary']['duration'] ?? 0,
    );
  }
}

// Search Result
class SearchResult {
  final String id;
  final String name;
  final String category;
  final String address;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String phone;
  final String url;
  final String description;

  SearchResult({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.url,
    required this.description,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      roadAddress: json['road_address'] ?? '',
      latitude: double.tryParse(json['y'] ?? '') ?? 0.0,
      longitude: double.tryParse(json['x'] ?? '') ?? 0.0,
      phone: json['phone'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// LatLng
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => '$latitude,$longitude';
}
