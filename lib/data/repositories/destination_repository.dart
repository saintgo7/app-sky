import '../../domain/entities/destination.dart';
import '../local/hive_service.dart';
import 'base_repository.dart';

// 여행지 Repository 구현
class DestinationRepository implements BaseRepository<Destination> {
  static const String _cacheKey = 'destinations';

  @override
  Future<Destination?> getById(String id) async {
    try {
      final destinations = await getAll();
      return destinations.cast<Destination?>().firstWhere(
        (dest) => dest?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      print('Get destination by id error: $e');
      return null;
    }
  }

  @override
  Future<List<Destination>> getAll() async {
    try {
      // 캐시된 데이터 확인
      final cached = HiveService.getFromCache<List<Destination>>(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }

      // 캐시가 없으면 빈 리스트 반환 (실제로는 API 호출)
      return [];
    } catch (e) {
      print('Get all destinations error: $e');
      return [];
    }
  }

  @override
  Future<Destination> create(Destination entity) async {
    try {
      final destinations = await getAll();
      destinations.add(entity);

      // 캐시 업데이트
      await HiveService.cacheData(
        key: _cacheKey,
        data: destinations,
        expiry: const Duration(hours: 24),
      );

      return entity;
    } catch (e) {
      print('Create destination error: $e');
      rethrow;
    }
  }

  @override
  Future<Destination> update(String id, Destination entity) async {
    try {
      final destinations = await getAll();
      final index = destinations.indexWhere((dest) => dest.id == id);

      if (index != -1) {
        destinations[index] = entity;

        // 캐시 업데이트
        await HiveService.cacheData(
          key: _cacheKey,
          data: destinations,
          expiry: const Duration(hours: 24),
        );
      }

      return entity;
    } catch (e) {
      print('Update destination error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      final destinations = await getAll();
      destinations.removeWhere((dest) => dest.id == id);

      // 캐시 업데이트
      await HiveService.cacheData(
        key: _cacheKey,
        data: destinations,
        expiry: const Duration(hours: 24),
      );

      return true;
    } catch (e) {
      print('Delete destination error: $e');
      return false;
    }
  }

  @override
  Future<List<Destination>> query({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
    int? offset,
  }) async {
    try {
      List<Destination> destinations = await getAll();

      // 필터링 적용
      if (filters != null) {
        destinations = _applyFilters(destinations, filters);
      }

      // 정렬 적용
      if (orderBy != null) {
        destinations = _applySorting(destinations, orderBy, descending);
      }

      // 페이지네이션 적용
      if (offset != null && offset > 0) {
        destinations = destinations.skip(offset).toList();
      }

      if (limit != null && limit > 0) {
        destinations = destinations.take(limit).toList();
      }

      return destinations;
    } catch (e) {
      print('Query destinations error: $e');
      return [];
    }
  }

  @override
  Future<List<Destination>> createMany(List<Destination> entities) async {
    try {
      final destinations = await getAll();
      destinations.addAll(entities);

      // 캐시 업데이트
      await HiveService.cacheData(
        key: _cacheKey,
        data: destinations,
        expiry: const Duration(hours: 24),
      );

      return entities;
    } catch (e) {
      print('Create many destinations error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Destination>> updateMany(List<Destination> entities) async {
    try {
      final destinations = await getAll();

      for (final entity in entities) {
        final index = destinations.indexWhere((dest) => dest.id == entity.id);
        if (index != -1) {
          destinations[index] = entity;
        }
      }

      // 캐시 업데이트
      await HiveService.cacheData(
        key: _cacheKey,
        data: destinations,
        expiry: const Duration(hours: 24),
      );

      return entities;
    } catch (e) {
      print('Update many destinations error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteMany(List<String> ids) async {
    try {
      final destinations = await getAll();
      destinations.removeWhere((dest) => ids.contains(dest.id));

      // 캐시 업데이트
      await HiveService.cacheData(
        key: _cacheKey,
        data: destinations,
        expiry: const Duration(hours: 24),
      );

      return true;
    } catch (e) {
      print('Delete many destinations error: $e');
      return false;
    }
  }

  @override
  Future<bool> exists(String id) async {
    final destination = await getById(id);
    return destination != null;
  }

  @override
  Future<int> count({Map<String, dynamic>? filters}) async {
    final destinations = await query(filters: filters);
    return destinations.length;
  }

  @override
  Future<void> clear() async {
    await HiveService.saveToCache(_cacheKey, []);
  }

  // 여행지별 쿼리 메서드들
  Future<List<Destination>> getPopularDestinations({int limit = 10}) async {
    return await query(
      filters: {'isPopular': true},
      orderBy: 'rating',
      descending: true,
      limit: limit,
    );
  }

  Future<List<Destination>> getDestinationsByCountry(String country) async {
    return await query(filters: {'country': country});
  }

  Future<List<Destination>> getDestinationsByCategory(String category) async {
    return await query(filters: {'categories': category});
  }

  Future<List<Destination>> searchDestinations(String query) async {
    final allDestinations = await getAll();
    return allDestinations.where((dest) {
      final searchText = '${dest.name} ${dest.country} ${dest.city} ${dest.description}'.toLowerCase();
      return searchText.contains(query.toLowerCase());
    }).toList();
  }

  Future<void> cacheDestinationsFromApi(List<Destination> destinations) async {
    await HiveService.cacheData(
      key: _cacheKey,
      data: destinations,
      expiry: const Duration(hours: 24),
    );
  }

  // 최근 본 여행지 관리
  Future<void> addToRecentDestinations(String destinationId) async {
    try {
      final recentIds = HiveService.getSetting('recent_destinations', defaultValue: <String>[]);
      recentIds.remove(destinationId); // 중복 제거
      recentIds.insert(0, destinationId); // 맨 앞에 추가

      // 최대 10개만 유지
      if (recentIds.length > 10) {
        recentIds.removeRange(10, recentIds.length);
      }

      await HiveService.saveSetting('recent_destinations', recentIds);
    } catch (e) {
      print('Add to recent destinations error: $e');
    }
  }

  Future<List<Destination>> getRecentDestinations() async {
    try {
      final recentIds = HiveService.getSetting('recent_destinations', defaultValue: <String>[]);
      final recentDestinations = <Destination>[];

      for (final id in recentIds) {
        final destination = await getById(id);
        if (destination != null) {
          recentDestinations.add(destination);
        }
      }

      return recentDestinations;
    } catch (e) {
      print('Get recent destinations error: $e');
      return [];
    }
  }

  // 즐겨찾기 여행지 관리
  Future<void> addToFavorites(String destinationId) async {
    try {
      final favorites = HiveService.getSetting('favorite_destinations', defaultValue: <String>[]);
      if (!favorites.contains(destinationId)) {
        favorites.add(destinationId);
        await HiveService.saveSetting('favorite_destinations', favorites);
      }
    } catch (e) {
      print('Add to favorites error: $e');
    }
  }

  Future<void> removeFromFavorites(String destinationId) async {
    try {
      final favorites = HiveService.getSetting('favorite_destinations', defaultValue: <String>[]);
      favorites.remove(destinationId);
      await HiveService.saveSetting('favorite_destinations', favorites);
    } catch (e) {
      print('Remove from favorites error: $e');
    }
  }

  Future<List<Destination>> getFavoriteDestinations() async {
    try {
      final favoriteIds = HiveService.getSetting('favorite_destinations', defaultValue: <String>[]);
      final favoriteDestinations = <Destination>[];

      for (final id in favoriteIds) {
        final destination = await getById(id);
        if (destination != null) {
          favoriteDestinations.add(destination);
        }
      }

      return favoriteDestinations;
    } catch (e) {
      print('Get favorite destinations error: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String destinationId) async {
    try {
      final favorites = HiveService.getSetting('favorite_destinations', defaultValue: <String>[]);
      return favorites.contains(destinationId);
    } catch (e) {
      return false;
    }
  }

  // 필터링 헬퍼 메서드
  List<Destination> _applyFilters(List<Destination> destinations, Map<String, dynamic> filters) {
    return destinations.where((dest) {
      for (final entry in filters.entries) {
        final field = entry.key;
        final value = entry.value;

        switch (field) {
          case 'country':
            if (dest.country != value) return false;
            break;
          case 'city':
            if (dest.city != value) return false;
            break;
          case 'categories':
            if (!dest.categories.contains(value)) return false;
            break;
          case 'minRating':
            if (dest.rating < value) return false;
            break;
          case 'isPopular':
            // 인기 여행지 필터링 로직 (실제로는 별도 필드나 계산 필요)
            if (dest.rating < 4.0 || dest.reviewCount < 100) return false;
            break;
          case 'attractions':
            if (!dest.attractions.any((attr) => attr.toLowerCase().contains(value.toLowerCase()))) return false;
            break;
        }
      }
      return true;
    }).toList();
  }

  // 정렬 헬퍼 메서드
  List<Destination> _applySorting(List<Destination> destinations, String orderBy, bool descending) {
    destinations.sort((a, b) {
      dynamic aValue, bValue;

      switch (orderBy) {
        case 'name':
          aValue = a.name;
          bValue = b.name;
          break;
        case 'rating':
          aValue = a.rating;
          bValue = b.rating;
          break;
        case 'reviewCount':
          aValue = a.reviewCount;
          bValue = b.reviewCount;
          break;
        case 'distance':
          // 거리 정렬은 현재 위치를 기준으로 해야 함
          // 간단히 구현을 위해 이름으로 정렬
          aValue = a.name;
          bValue = b.name;
          break;
        default:
          aValue = a.createdAt;
          bValue = b.createdAt;
      }

      if (descending) {
        return bValue.compareTo(aValue);
      } else {
        return aValue.compareTo(bValue);
      }
    });

    return destinations;
  }
}

// 싱글톤 인스턴스
final destinationRepository = DestinationRepository();
