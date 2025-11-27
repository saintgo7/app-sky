import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../core/environment/env_config.dart';
import 'google_map_service.dart';
import 'naver_map_service.dart';

// 통합 지도 서비스
class MapService {
  static MapProvider _currentProvider = MapProvider.google;

  // 현재 지도 제공자 설정
  static void setMapProvider(MapProvider provider) {
    _currentProvider = provider;
  }

  // 현재 지도 제공자 가져오기
  static MapProvider getCurrentProvider() {
    return _currentProvider;
  }

  // 위치 권한 확인 및 요청
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // 현재 위치 가져오기
  static Future<gmaps.LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return gmaps.LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Get current location error: $e');
      return null;
    }
  }

  // 위치 업데이트 스트림
  static Stream<gmaps.LatLng> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터마다 업데이트
      ),
    ).map((position) => gmaps.LatLng(position.latitude, position.longitude));
  }

  // 경로 검색
  static Future<MapRouteResult?> getDirections({
    required gmaps.LatLng origin,
    required gmaps.LatLng destination,
    String mode = 'driving',
    List<gmaps.LatLng>? waypoints,
  }) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final result = await GoogleMapService.getDirections(
            origin: origin,
            destination: destination,
            mode: mode,
            waypoints: waypoints,
          );
          return result != null ? MapRouteResult.fromGoogle(result) : null;

        case MapProvider.naver:
          final result = await NaverMapService.getDirections(
            startLat: origin.latitude,
            startLng: origin.longitude,
            endLat: destination.latitude,
            endLng: destination.longitude,
          );
          return result != null ? MapRouteResult.fromNaver(result) : null;
      }
    } catch (e) {
      print('Get directions error: $e');
    }
    return null;
  }

  // 장소 검색
  static Future<List<MapPlace>> searchPlaces({
    required String query,
    gmaps.LatLng? location,
    int radius = 5000,
    String? type,
  }) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final results = await GoogleMapService.searchPlaces(
            query: query,
            location: location,
            radius: radius,
            type: type,
          );
          return results.map((place) => MapPlace.fromGoogle(place)).toList();

        case MapProvider.naver:
          final results = await NaverMapService.searchPlaces(
            query: query,
          );
          return results.map((place) => MapPlace.fromNaver(place)).toList();
      }
    } catch (e) {
      print('Search places error: $e');
    }
    return [];
  }

  // 주변 검색
  static Future<List<MapPlace>> searchNearby({
    required gmaps.LatLng location,
    int radius = 5000,
    String? type,
    String? keyword,
  }) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final results = await GoogleMapService.searchNearby(
            location: location,
            radius: radius,
            type: type,
            keyword: keyword,
          );
          return results.map((place) => MapPlace.fromGoogle(place)).toList();

        case MapProvider.naver:
          // Naver는 주변 검색을 지원하지 않으므로 일반 검색 사용
          final results = await NaverMapService.searchPlaces(
            query: keyword ?? type ?? '관광지',
          );
          return results.map((place) => MapPlace.fromNaver(place)).toList();
      }
    } catch (e) {
      print('Search nearby error: $e');
    }
    return [];
  }

  // 장소 상세 정보
  static Future<MapPlaceDetail?> getPlaceDetails(String placeId) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final result = await GoogleMapService.getPlaceDetails(placeId: placeId);
          return result != null ? MapPlaceDetail.fromGoogle(result) : null;

        case MapProvider.naver:
          // Naver는 상세 정보 API가 제한적
          return null;
      }
    } catch (e) {
      print('Get place details error: $e');
    }
    return null;
  }

  // 주소로 좌표 찾기 (Geocoding)
  static Future<List<MapGeocodeResult>> geocode(String address) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final results = await GoogleMapService.geocode(address: address);
          return results.map((result) => MapGeocodeResult.fromGoogle(result)).toList();

        case MapProvider.naver:
          final results = await NaverMapService.geocode(address);
          return results.map((result) => MapGeocodeResult.fromNaver(result)).toList();
      }
    } catch (e) {
      print('Geocode error: $e');
    }
    return [];
  }

  // 좌표로 주소 찾기 (Reverse Geocoding)
  static Future<List<MapGeocodeResult>> reverseGeocode(gmaps.LatLng location) async {
    try {
      switch (_currentProvider) {
        case MapProvider.google:
          final results = await GoogleMapService.reverseGeocode(location: location);
          return results.map((result) => MapGeocodeResult.fromGoogle(result)).toList();

        case MapProvider.naver:
          final result = await NaverMapService.reverseGeocode(location.latitude, location.longitude);
          return result != null ? [MapGeocodeResult.fromNaver(result)] : [];
      }
    } catch (e) {
      print('Reverse geocode error: $e');
    }
    return [];
  }

  // 두 지점 간 거리 계산
  static double calculateDistance(gmaps.LatLng point1, gmaps.LatLng point2) {
    switch (_currentProvider) {
      case MapProvider.google:
        return GoogleMapService.calculateDistance(point1, point2);
      case MapProvider.naver:
        return NaverMapService.calculateDistance(point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    }
  }

  // 정적 지도 이미지 URL 생성
  static String getStaticMapUrl({
    required gmaps.LatLng center,
    int zoom = 15,
    int width = 400,
    int height = 400,
    List<MapPlace>? markers,
    List<gmaps.LatLng>? path,
  }) {
    if (_currentProvider == MapProvider.google) {
      return GoogleMapService.getStaticMapUrl(
        center: center,
        zoom: zoom,
        width: width,
        height: height,
        markers: markers?.map((m) => GooglePlace(
          placeId: m.placeId,
          name: m.name,
          rating: m.rating,
          userRatingsTotal: m.reviewCount,
          geometry: GoogleGeometry(location: m.location),
          types: [],
          openNow: false,
        )).toList(),
        path: path,
      );
    }

    // Naver는 정적 지도를 지원하지 않으므로 기본 이미지 URL 반환
    return 'https://navermaps.github.io/ios-map-sdk/assets/img/logo_naver_s.png';
  }
}

// 지도 제공자
enum MapProvider {
  google,
  naver,
}

// 통합 경로 결과
class MapRouteResult {
  final List<MapRoute> routes;
  final String status;

  MapRouteResult({
    required this.routes,
    required this.status,
  });

  factory MapRouteResult.fromGoogle(GoogleDirectionsResult googleResult) {
    return MapRouteResult(
      routes: googleResult.routes.map((route) => MapRoute.fromGoogle(route)).toList(),
      status: googleResult.status,
    );
  }

  factory MapRouteResult.fromNaver(DirectionsResult naverResult) {
    return MapRouteResult(
      routes: naverResult.routes.map((route) => MapRoute.fromNaver(route)).toList(),
      status: 'OK', // Naver는 항상 성공으로 가정
    );
  }
}

class MapRoute {
  final MapRouteLeg leg;
  final List<gmaps.LatLng> polylinePoints;

  MapRoute({
    required this.leg,
    required this.polylinePoints,
  });

  factory MapRoute.fromGoogle(GoogleRoute googleRoute) {
    return MapRoute(
      leg: MapRouteLeg.fromGoogle(googleRoute.leg),
      polylinePoints: googleRoute.polylinePoints,
    );
  }

  factory MapRoute.fromNaver(Route naverRoute) {
    return MapRoute(
      leg: MapRouteLeg.fromNaver(naverRoute),
      polylinePoints: naverRoute.path,
    );
  }
}

class MapRouteLeg {
  final MapDistance distance;
  final MapDuration duration;
  final String startAddress;
  final String endAddress;

  MapRouteLeg({
    required this.distance,
    required this.duration,
    required this.startAddress,
    required this.endAddress,
  });

  factory MapRouteLeg.fromGoogle(GoogleRouteLeg googleLeg) {
    return MapRouteLeg(
      distance: MapDistance.fromGoogle(googleLeg.distance),
      duration: MapDuration.fromGoogle(googleLeg.duration),
      startAddress: googleLeg.startAddress,
      endAddress: googleLeg.endAddress,
    );
  }

  factory MapRouteLeg.fromNaver(Route naverRoute) {
    return MapRouteLeg(
      distance: MapDistance(
        value: naverRoute.distance,
        text: '${(naverRoute.distance / 1000).toStringAsFixed(1)} km',
      ),
      duration: MapDuration(
        value: naverRoute.duration,
        text: '${(naverRoute.duration / 60).toStringAsFixed(0)}분',
      ),
      startAddress: '출발지',
      endAddress: '도착지',
    );
  }
}

class MapDistance {
  final int value; // meters
  final String text;

  MapDistance({required this.value, required this.text});

  factory MapDistance.fromGoogle(GoogleDistance googleDistance) {
    return MapDistance(
      value: googleDistance.value,
      text: googleDistance.text,
    );
  }
}

class MapDuration {
  final int value; // seconds
  final String text;

  MapDuration({required this.value, required this.text});

  factory MapDuration.fromGoogle(GoogleDuration googleDuration) {
    return MapDuration(
      value: googleDuration.value,
      text: googleDuration.text,
    );
  }
}

// 통합 장소
class MapPlace {
  final String placeId;
  final String name;
  final String? address;
  final double rating;
  final int reviewCount;
  final gmaps.LatLng location;
  final List<String> types;
  final String? photoUrl;
  final bool openNow;
  final String? priceLevel;

  MapPlace({
    required this.placeId,
    required this.name,
    this.address,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.types,
    this.photoUrl,
    required this.openNow,
    this.priceLevel,
  });

  factory MapPlace.fromGoogle(GooglePlace googlePlace) {
    return MapPlace(
      placeId: googlePlace.placeId,
      name: googlePlace.name,
      address: googlePlace.address,
      rating: googlePlace.rating,
      reviewCount: googlePlace.userRatingsTotal,
      location: googlePlace.geometry.location,
      types: googlePlace.types,
      photoUrl: googlePlace.photo?.getPhotoUrl(),
      openNow: googlePlace.openNow,
      priceLevel: googlePlace.priceLevel?.name,
    );
  }

  factory MapPlace.fromNaver(SearchResult naverPlace) {
    return MapPlace(
      placeId: naverPlace.id,
      name: naverPlace.name,
      address: naverPlace.address,
      rating: 0.0, // Naver는 평점 제공 안함
      reviewCount: 0,
      location: gmaps.LatLng(naverPlace.latitude, naverPlace.longitude),
      types: [naverPlace.category],
      photoUrl: null,
      openNow: false,
      priceLevel: null,
    );
  }
}

// 통합 장소 상세 정보
class MapPlaceDetail {
  final String placeId;
  final String name;
  final String? address;
  final String? phoneNumber;
  final String? website;
  final double rating;
  final int reviewCount;
  final List<String> photos;

  MapPlaceDetail({
    required this.placeId,
    required this.name,
    this.address,
    this.phoneNumber,
    this.website,
    required this.rating,
    required this.reviewCount,
    required this.photos,
  });

  factory MapPlaceDetail.fromGoogle(GooglePlaceDetail googleDetail) {
    return MapPlaceDetail(
      placeId: googleDetail.placeId,
      name: googleDetail.name,
      address: googleDetail.formattedAddress,
      phoneNumber: googleDetail.formattedPhoneNumber,
      website: googleDetail.website,
      rating: googleDetail.rating,
      reviewCount: googleDetail.userRatingsTotal,
      photos: googleDetail.photos.map((photo) => photo.getPhotoUrl()).toList(),
    );
  }
}

// 통합 지오코딩 결과
class MapGeocodeResult {
  final String formattedAddress;
  final gmaps.LatLng location;
  final String placeId;

  MapGeocodeResult({
    required this.formattedAddress,
    required this.location,
    required this.placeId,
  });

  factory MapGeocodeResult.fromGoogle(GoogleGeocodeResult googleResult) {
    return MapGeocodeResult(
      formattedAddress: googleResult.formattedAddress,
      location: googleResult.geometry.location,
      placeId: googleResult.placeId,
    );
  }

  factory MapGeocodeResult.fromNaver(GeocodingResult naverResult) {
    return MapGeocodeResult(
      formattedAddress: naverResult.address,
      location: gmaps.LatLng(naverResult.latitude, naverResult.longitude),
      placeId: 'naver_${naverResult.latitude}_${naverResult.longitude}',
    );
  }
}
