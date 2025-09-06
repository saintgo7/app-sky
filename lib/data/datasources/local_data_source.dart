import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';
import '../models/travel_package_model.dart';
import '../models/booking_model.dart';
import '../models/ai_recommendation_model.dart';
import '../../core/error/exceptions.dart';

abstract class LocalDataSource {
  // Authentication data
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearAccessToken();
  Future<void> clearRefreshToken();
  
  // User data
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUserCache();
  
  // Travel packages cache
  Future<void> cacheTravelPackages(List<TravelPackageModel> packages);
  Future<List<TravelPackageModel>> getCachedTravelPackages();
  Future<void> cacheTravelPackage(TravelPackageModel package);
  Future<TravelPackageModel?> getCachedTravelPackage(String id);
  
  // Bookings cache
  Future<void> cacheBookings(List<BookingModel> bookings);
  Future<List<BookingModel>> getCachedBookings();
  Future<void> cacheBooking(BookingModel booking);
  Future<BookingModel?> getCachedBooking(String id);
  
  // AI Recommendations cache
  Future<void> cacheRecommendations(List<AIRecommendationModel> recommendations);
  Future<List<AIRecommendationModel>> getCachedRecommendations();
  
  // Search history
  Future<void> saveSearchQuery(String query);
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
  
  // App settings
  Future<void> saveSetting(String key, dynamic value);
  Future<T?> getSetting<T>(String key);
  Future<void> removeSetting(String key);
  
  // Offline sync data
  Future<void> savePendingSync(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getPendingSync(String key);
  Future<List<String>> getAllPendingSyncKeys();
  Future<void> removePendingSync(String key);
  Future<void> clearAllPendingSync();
  
  // Cache management
  Future<void> clearAllCache();
  Future<int> getCacheSize();
  Future<void> cleanExpiredCache();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  late Box<String> _tokenBox;
  late Box<UserModel> _userBox;
  late Box<TravelPackageModel> _packagesBox;
  late Box<BookingModel> _bookingsBox;
  late Box<AIRecommendationModel> _recommendationsBox;
  late Box<Map> _settingsBox;
  late Box<Map> _syncBox;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'current_user';
  static const String _searchHistoryKey = 'search_history';

  LocalDataSourceImpl(this.sharedPreferences);

  Future<void> init() async {
    _tokenBox = await Hive.openBox<String>('tokens');
    _userBox = await Hive.openBox<UserModel>('user');
    _packagesBox = await Hive.openBox<TravelPackageModel>('packages');
    _bookingsBox = await Hive.openBox<BookingModel>('bookings');
    _recommendationsBox = await Hive.openBox<AIRecommendationModel>('recommendations');
    _settingsBox = await Hive.openBox<Map>('settings');
    _syncBox = await Hive.openBox<Map>('pending_sync');
  }

  // Authentication data
  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _tokenBox.put(_accessTokenKey, token);
    } catch (e) {
      throw CacheException('Failed to save access token');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _tokenBox.put(_refreshTokenKey, token);
    } catch (e) {
      throw CacheException('Failed to save refresh token');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _tokenBox.get(_accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _tokenBox.get(_refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token');
    }
  }

  @override
  Future<void> clearAccessToken() async {
    try {
      await _tokenBox.delete(_accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear access token');
    }
  }

  @override
  Future<void> clearRefreshToken() async {
    try {
      await _tokenBox.delete(_refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear refresh token');
    }
  }

  // User data
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _userBox.put(_userKey, user);
    } catch (e) {
      throw CacheException('Failed to cache user data');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      return _userBox.get(_userKey);
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> clearUserCache() async {
    try {
      await _userBox.delete(_userKey);
    } catch (e) {
      throw CacheException('Failed to clear user cache');
    }
  }

  // Travel packages cache
  @override
  Future<void> cacheTravelPackages(List<TravelPackageModel> packages) async {
    try {
      final Map<String, TravelPackageModel> packagesMap = {
        for (var package in packages) package.id: package
      };
      await _packagesBox.putAll(packagesMap);
      
      // Save timestamp for cache validation
      await _settingsBox.put('packages_cache_time', {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw CacheException('Failed to cache travel packages');
    }
  }

  @override
  Future<List<TravelPackageModel>> getCachedTravelPackages() async {
    try {
      // Check if cache is still valid (24 hours)
      final cacheTime = _settingsBox.get('packages_cache_time') as Map?;
      if (cacheTime != null) {
        final timestamp = cacheTime['timestamp'] as int;
        final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheDate).inHours > 24) {
          return [];
        }
      }
      
      return _packagesBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get cached travel packages');
    }
  }

  @override
  Future<void> cacheTravelPackage(TravelPackageModel package) async {
    try {
      await _packagesBox.put(package.id, package);
    } catch (e) {
      throw CacheException('Failed to cache travel package');
    }
  }

  @override
  Future<TravelPackageModel?> getCachedTravelPackage(String id) async {
    try {
      return _packagesBox.get(id);
    } catch (e) {
      throw CacheException('Failed to get cached travel package');
    }
  }

  // Bookings cache
  @override
  Future<void> cacheBookings(List<BookingModel> bookings) async {
    try {
      final Map<String, BookingModel> bookingsMap = {
        for (var booking in bookings) booking.id: booking
      };
      await _bookingsBox.putAll(bookingsMap);
    } catch (e) {
      throw CacheException('Failed to cache bookings');
    }
  }

  @override
  Future<List<BookingModel>> getCachedBookings() async {
    try {
      return _bookingsBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get cached bookings');
    }
  }

  @override
  Future<void> cacheBooking(BookingModel booking) async {
    try {
      await _bookingsBox.put(booking.id, booking);
    } catch (e) {
      throw CacheException('Failed to cache booking');
    }
  }

  @override
  Future<BookingModel?> getCachedBooking(String id) async {
    try {
      return _bookingsBox.get(id);
    } catch (e) {
      throw CacheException('Failed to get cached booking');
    }
  }

  // AI Recommendations cache
  @override
  Future<void> cacheRecommendations(List<AIRecommendationModel> recommendations) async {
    try {
      // Clear expired recommendations first
      await _cleanExpiredRecommendations();
      
      final Map<String, AIRecommendationModel> recommendationsMap = {
        for (var rec in recommendations) rec.id: rec
      };
      await _recommendationsBox.putAll(recommendationsMap);
    } catch (e) {
      throw CacheException('Failed to cache recommendations');
    }
  }

  @override
  Future<List<AIRecommendationModel>> getCachedRecommendations() async {
    try {
      await _cleanExpiredRecommendations();
      return _recommendationsBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get cached recommendations');
    }
  }

  Future<void> _cleanExpiredRecommendations() async {
    try {
      final now = DateTime.now();
      final expiredKeys = <String>[];
      
      for (final entry in _recommendationsBox.toMap().entries) {
        if (entry.value.expiresAt.isBefore(now)) {
          expiredKeys.add(entry.key);
        }
      }
      
      await _recommendationsBox.deleteAll(expiredKeys);
    } catch (e) {
      // Log error but don't throw - this is a cleanup operation
      print('Failed to clean expired recommendations: $e');
    }
  }

  // Search history
  @override
  Future<void> saveSearchQuery(String query) async {
    try {
      final history = await getSearchHistory();
      
      // Remove if already exists and add to front
      history.remove(query);
      history.insert(0, query);
      
      // Keep only last 50 searches
      if (history.length > 50) {
        history.removeRange(50, history.length);
      }
      
      await sharedPreferences.setStringList(_searchHistoryKey, history);
    } catch (e) {
      throw CacheException('Failed to save search query');
    }
  }

  @override
  Future<List<String>> getSearchHistory() async {
    try {
      return sharedPreferences.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      throw CacheException('Failed to get search history');
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await sharedPreferences.remove(_searchHistoryKey);
    } catch (e) {
      throw CacheException('Failed to clear search history');
    }
  }

  // App settings
  @override
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox.put(key, {'value': value});
    } catch (e) {
      throw CacheException('Failed to save setting: $key');
    }
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    try {
      final data = _settingsBox.get(key) as Map?;
      return data?['value'] as T?;
    } catch (e) {
      throw CacheException('Failed to get setting: $key');
    }
  }

  @override
  Future<void> removeSetting(String key) async {
    try {
      await _settingsBox.delete(key);
    } catch (e) {
      throw CacheException('Failed to remove setting: $key');
    }
  }

  // Offline sync data
  @override
  Future<void> savePendingSync(String key, Map<String, dynamic> data) async {
    try {
      await _syncBox.put(key, {
        ...data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw CacheException('Failed to save pending sync data');
    }
  }

  @override
  Future<Map<String, dynamic>?> getPendingSync(String key) async {
    try {
      final data = _syncBox.get(key) as Map?;
      return data?.cast<String, dynamic>();
    } catch (e) {
      throw CacheException('Failed to get pending sync data');
    }
  }

  @override
  Future<List<String>> getAllPendingSyncKeys() async {
    try {
      return _syncBox.keys.cast<String>().toList();
    } catch (e) {
      throw CacheException('Failed to get pending sync keys');
    }
  }

  @override
  Future<void> removePendingSync(String key) async {
    try {
      await _syncBox.delete(key);
    } catch (e) {
      throw CacheException('Failed to remove pending sync data');
    }
  }

  @override
  Future<void> clearAllPendingSync() async {
    try {
      await _syncBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear all pending sync data');
    }
  }

  // Cache management
  @override
  Future<void> clearAllCache() async {
    try {
      await Future.wait([
        _userBox.clear(),
        _packagesBox.clear(),
        _bookingsBox.clear(),
        _recommendationsBox.clear(),
        _settingsBox.clear(),
        _syncBox.clear(),
        sharedPreferences.clear(),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear all cache');
    }
  }

  @override
  Future<int> getCacheSize() async {
    try {
      // Approximate cache size calculation
      int size = 0;
      size += _userBox.length;
      size += _packagesBox.length * 1000; // Approximate package size
      size += _bookingsBox.length * 500; // Approximate booking size
      size += _recommendationsBox.length * 300; // Approximate recommendation size
      size += _settingsBox.length * 100;
      size += _syncBox.length * 200;
      
      return size;
    } catch (e) {
      throw CacheException('Failed to get cache size');
    }
  }

  @override
  Future<void> cleanExpiredCache() async {
    try {
      await _cleanExpiredRecommendations();
      
      // Clean old package cache
      final cacheTime = _settingsBox.get('packages_cache_time') as Map?;
      if (cacheTime != null) {
        final timestamp = cacheTime['timestamp'] as int;
        final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheDate).inDays > 7) {
          await _packagesBox.clear();
          await _settingsBox.delete('packages_cache_time');
        }
      }
      
      // Clean old pending sync data (older than 30 days)
      final keysToRemove = <String>[];
      for (final key in _syncBox.keys.cast<String>()) {
        final data = _syncBox.get(key) as Map?;
        if (data != null) {
          final timestamp = data['timestamp'] as int?;
          if (timestamp != null) {
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (DateTime.now().difference(date).inDays > 30) {
              keysToRemove.add(key);
            }
          }
        }
      }
      
      if (keysToRemove.isNotEmpty) {
        await _syncBox.deleteAll(keysToRemove);
      }
    } catch (e) {
      // Log error but don't throw - this is a cleanup operation
      print('Failed to clean expired cache: $e');
    }
  }
}