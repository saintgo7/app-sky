import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../services/map_service.dart';

class TravelMapWidget extends StatefulWidget {
  final gmaps.LatLng? initialLocation;
  final double initialZoom;
  final bool showMyLocation;
  final bool showMyLocationButton;
  final Set<gmaps.Marker>? markers;
  final Set<gmaps.Polyline>? polylines;
  final Function(gmaps.LatLng)? onTap;
  final Function(gmaps.CameraPosition)? onCameraMove;
  final MapProvider? forceProvider;

  const TravelMapWidget({
    super.key,
    this.initialLocation,
    this.initialZoom = 15.0,
    this.showMyLocation = true,
    this.showMyLocationButton = true,
    this.markers,
    this.polylines,
    this.onTap,
    this.onCameraMove,
    this.forceProvider,
  });

  @override
  State<TravelMapWidget> createState() => _TravelMapWidgetState();
}

class _TravelMapWidgetState extends State<TravelMapWidget> {
  gmaps.GoogleMapController? _googleMapController;
  MapProvider _currentProvider = MapProvider.google;

  @override
  void initState() {
    super.initState();
    _currentProvider = widget.forceProvider ?? MapService.getCurrentProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 지도 위젯
        _buildMapWidget(),

        // 지도 제공자 전환 버튼
        if (widget.forceProvider == null)
          Positioned(
            top: 16,
            right: 16,
            child: _buildProviderSwitch(),
          ),

        // 내 위치 버튼
        if (widget.showMyLocationButton)
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildMyLocationButton(),
          ),
      ],
    );
  }

  Widget _buildMapWidget() {
    switch (_currentProvider) {
      case MapProvider.google:
        return _buildGoogleMap();
      case MapProvider.naver:
        return _buildNaverMapPlaceholder();
    }
  }

  Widget _buildGoogleMap() {
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: widget.initialLocation ?? const gmaps.LatLng(37.5665, 126.9780), // 서울 기본 위치
        zoom: widget.initialZoom,
      ),
      myLocationEnabled: widget.showMyLocation,
      myLocationButtonEnabled: false, // 커스텀 버튼 사용
      markers: widget.markers ?? {},
      polylines: widget.polylines ?? {},
      onTap: widget.onTap,
      onCameraMove: widget.onCameraMove,
      onMapCreated: (controller) {
        _googleMapController = controller;
        // 지도 스타일 적용 (선택사항)
        _applyMapStyle();
      },
    );
  }

  Widget _buildNaverMapPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '네이버 지도',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '네이버 지도 SDK 통합 예정',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProviderButton(MapProvider.google, 'Google'),
          _buildProviderButton(MapProvider.naver, 'Naver'),
        ],
      ),
    );
  }

  Widget _buildProviderButton(MapProvider provider, String label) {
    final isSelected = _currentProvider == provider;

    return InkWell(
      onTap: () {
        setState(() {
          _currentProvider = provider;
          MapService.setMapProvider(provider);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return FloatingActionButton(
      onPressed: _moveToMyLocation,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(Icons.my_location),
    );
  }

  Future<void> _moveToMyLocation() async {
    final currentLocation = await MapService.getCurrentLocation();
    if (currentLocation != null && _googleMapController != null) {
      await _googleMapController!.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(currentLocation, 16),
      );
    }
  }

  void _applyMapStyle() {
    // Google Maps 스타일 적용 (선택사항)
    const String mapStyle = '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      }
    ]
    ''';

    _googleMapController?.setMapStyle(mapStyle);
  }

  // 외부에서 지도 컨트롤을 위한 메서드들
  Future<void> animateCamera(gmaps.CameraUpdate cameraUpdate) async {
    if (_googleMapController != null) {
      await _googleMapController!.animateCamera(cameraUpdate);
    }
  }

  Future<void> moveCamera(gmaps.CameraUpdate cameraUpdate) async {
    if (_googleMapController != null) {
      await _googleMapController!.moveCamera(cameraUpdate);
    }
  }

  Future<gmaps.LatLngBounds> getVisibleRegion() async {
    if (_googleMapController != null) {
      return await _googleMapController!.getVisibleRegion();
    }
    return gmaps.LatLngBounds(
      southwest: const gmaps.LatLng(0, 0),
      northeast: const gmaps.LatLng(0, 0),
    );
  }

  Future<gmaps.LatLng> getCenter() async {
    if (_googleMapController != null) {
      final bounds = await _googleMapController!.getVisibleRegion();
      final centerLat = (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
      final centerLng = (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
      return gmaps.LatLng(centerLat, centerLng);
    }
    return const gmaps.LatLng(37.5665, 126.9780); // 서울 기본 위치
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}

// 간단한 지도 마커 생성 헬퍼
class MapMarker {
  static gmaps.Marker create({
    required String markerId,
    required gmaps.LatLng position,
    String? title,
    String? snippet,
    VoidCallback? onTap,
    gmaps.BitmapDescriptor? icon,
  }) {
    return gmaps.Marker(
      markerId: gmaps.MarkerId(markerId),
      position: position,
      infoWindow: title != null
          ? gmaps.InfoWindow(
              title: title,
              snippet: snippet,
            )
          : gmaps.InfoWindow.noText,
      icon: icon ?? gmaps.BitmapDescriptor.defaultMarker,
      onTap: onTap,
    );
  }

  // 커스텀 마커 아이콘 생성
  static Future<gmaps.BitmapDescriptor> createCustomIcon({
    required Color color,
    double size = 48.0,
  }) async {
    // 간단한 구현 - 실제로는 Canvas를 사용한 커스텀 아이콘 생성
    return gmaps.BitmapDescriptor.defaultMarkerWithHue(
      _colorToHue(color),
    );
  }

  static double _colorToHue(Color color) {
    // 색상을 HSV의 Hue 값으로 변환
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    final max = [r, g, b].reduce((a, b) => a > b ? a : b);
    final min = [r, g, b].reduce((a, b) => a < b ? a : b);
    final delta = max - min;

    if (delta == 0) return 0;

    double hue;
    if (max == r) {
      hue = ((g - b) / delta) % 6;
    } else if (max == g) {
      hue = (b - r) / delta + 2;
    } else {
      hue = (r - g) / delta + 4;
    }

    hue *= 60;
    if (hue < 0) hue += 360;

    return hue;
  }
}

// 지도 폴리라인 생성 헬퍼
class MapPolyline {
  static gmaps.Polyline create({
    required String polylineId,
    required List<gmaps.LatLng> points,
    Color color = Colors.blue,
    double width = 5.0,
    List<gmaps.PatternItem> patterns = const [],
  }) {
    return gmaps.Polyline(
      polylineId: gmaps.PolylineId(polylineId),
      points: points,
      color: color,
      width: width.toInt(),
      patterns: patterns,
    );
  }

  // 경로용 폴리라인 생성
  static gmaps.Polyline createRoute({
    required String routeId,
    required List<gmaps.LatLng> points,
  }) {
    return create(
      polylineId: routeId,
      points: points,
      color: AppColors.primary,
      width: 6.0,
    );
  }
}

// 지도 카메라 업데이트 헬퍼
class MapCameraUpdate {
  static gmaps.CameraUpdate newLatLng(gmaps.LatLng latLng) {
    return gmaps.CameraUpdate.newLatLng(latLng);
  }

  static gmaps.CameraUpdate newLatLngZoom(gmaps.LatLng latLng, double zoom) {
    return gmaps.CameraUpdate.newLatLngZoom(latLng, zoom);
  }

  static gmaps.CameraUpdate newLatLngBounds(gmaps.LatLngBounds bounds, double padding) {
    return gmaps.CameraUpdate.newLatLngBounds(bounds, padding);
  }

  static gmaps.CameraUpdate zoomIn() {
    return gmaps.CameraUpdate.zoomIn();
  }

  static gmaps.CameraUpdate zoomOut() {
    return gmaps.CameraUpdate.zoomOut();
  }

  static gmaps.CameraUpdate zoomTo(double zoom) {
    return gmaps.CameraUpdate.zoomTo(zoom);
  }
}
