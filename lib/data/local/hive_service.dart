import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/environment/env_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/hotel.dart';

class HiveService {
  static const String _userBox = 'user';
  static const String _bookingsBox = 'bookings';
  static const String _destinationsBox = 'destinations';
  static const String _flightsBox = 'flights';
  static const String _hotelsBox = 'hotels';
  static const String _cacheBox = 'cache';
  static const String _settingsBox = 'settings';

  // Initialize Hive
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register adapters
    _registerAdapters();

    // Open boxes
    await Future.wait([
      Hive.openBox(_userBox),
      Hive.openBox(_bookingsBox),
      Hive.openBox(_destinationsBox),
      Hive.openBox(_flightsBox),
      Hive.openBox(_hotelsBox),
      Hive.openBox(_cacheBox),
      Hive.openBox(_settingsBox),
    ]);
  }

  static void _registerAdapters() {
    // User adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(UserRoleAdapter());

    // Booking adapters
    Hive.registerAdapter(BookingAdapter());
    Hive.registerAdapter(BookingTypeAdapter());
    Hive.registerAdapter(BookingStatusAdapter());
    Hive.registerAdapter(BookingItemAdapter());
    Hive.registerAdapter(TravelerAdapter());
    Hive.registerAdapter(ContactPersonAdapter());
    Hive.registerAdapter(PaymentInfoAdapter());
    Hive.registerAdapter(BookingUpdateAdapter());
    Hive.registerAdapter(BookingUpdateTypeAdapter());

    // Destination adapters
    Hive.registerAdapter(DestinationAdapter());
    Hive.registerAdapter(DestinationCategoryAdapter());
    Hive.registerAdapter(AttractionAdapter());
    Hive.registerAdapter(AttractionTypeAdapter());

    // Flight adapters
    Hive.registerAdapter(FlightAdapter());
    Hive.registerAdapter(AirlineAdapter());
    Hive.registerAdapter(AirportAdapter());
    Hive.registerAdapter(FlightStopAdapter());
    Hive.registerAdapter(FlightClassAdapter());
    Hive.registerAdapter(FlightStatusAdapter());

    // Hotel adapters
    Hive.registerAdapter(HotelAdapter());
    Hive.registerAdapter(HotelRatingAdapter());
    Hive.registerAdapter(RoomTypeAdapter());
    Hive.registerAdapter(HotelChainAdapter());
    Hive.registerAdapter(ContactInfoAdapter());
  }

  // User operations
  static Future<void> saveUser(User user) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', user);
  }

  static User? getUser() {
    final box = Hive.box(_userBox);
    return box.get('current_user');
  }

  static Future<void> clearUser() async {
    final box = Hive.box(_userBox);
    await box.delete('current_user');
  }

  // Booking operations
  static Future<void> saveBookings(List<Booking> bookings) async {
    final box = Hive.box(_bookingsBox);
    await box.put('all_bookings', bookings);
  }

  static List<Booking> getBookings() {
    final box = Hive.box(_bookingsBox);
    return box.get('all_bookings', defaultValue: <Booking>[]);
  }

  static Future<void> addBooking(Booking booking) async {
    final bookings = getBookings();
    bookings.add(booking);
    await saveBookings(bookings);
  }

  static Future<void> updateBooking(String bookingId, Booking updatedBooking) async {
    final bookings = getBookings();
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      bookings[index] = updatedBooking;
      await saveBookings(bookings);
    }
  }

  static Future<void> deleteBooking(String bookingId) async {
    final bookings = getBookings();
    bookings.removeWhere((b) => b.id == bookingId);
    await saveBookings(bookings);
  }

  // Destination operations
  static Future<void> cacheDestinations(List<Destination> destinations) async {
    final box = Hive.box(_destinationsBox);
    await box.put('cached_destinations', destinations);
    await box.put('cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static List<Destination>? getCachedDestinations() {
    final box = Hive.box(_destinationsBox);
    final timestamp = box.get('cache_timestamp');
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    // Check if cache is still valid (24 hours)
    if (now.difference(cacheTime) > EnvConfig.cacheDuration) {
      return null;
    }

    return box.get('cached_destinations');
  }

  static Future<void> saveRecentDestinations(List<Destination> destinations) async {
    final box = Hive.box(_destinationsBox);
    await box.put('recent_destinations', destinations.take(5).toList());
  }

  static List<Destination> getRecentDestinations() {
    final box = Hive.box(_destinationsBox);
    return box.get('recent_destinations', defaultValue: <Destination>[]);
  }

  // Flight operations
  static Future<void> cacheFlights(List<Flight> flights, String searchKey) async {
    final box = Hive.box(_flightsBox);
    await box.put('flights_$searchKey', flights);
    await box.put('flights_timestamp_$searchKey', DateTime.now().millisecondsSinceEpoch);
  }

  static List<Flight>? getCachedFlights(String searchKey) {
    final box = Hive.box(_flightsBox);
    final timestamp = box.get('flights_timestamp_$searchKey');
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (now.difference(cacheTime) > const Duration(hours: 2)) {
      return null;
    }

    return box.get('flights_$searchKey');
  }

  // Hotel operations
  static Future<void> cacheHotels(List<Hotel> hotels, String searchKey) async {
    final box = Hive.box(_hotelsBox);
    await box.put('hotels_$searchKey', hotels);
    await box.put('hotels_timestamp_$searchKey', DateTime.now().millisecondsSinceEpoch);
  }

  static List<Hotel>? getCachedHotels(String searchKey) {
    final box = Hive.box(_hotelsBox);
    final timestamp = box.get('hotels_timestamp_$searchKey');
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (now.difference(cacheTime) > const Duration(hours: 2)) {
      return null;
    }

    return box.get('hotels_$searchKey');
  }

  // Cache operations
  static Future<void> saveToCache(String key, dynamic value) async {
    final box = Hive.box(_cacheBox);
    await box.put(key, value);
    await box.put('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static T? getFromCache<T>(String key) {
    final box = Hive.box(_cacheBox);
    final timestamp = box.get('${key}_timestamp');
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (now.difference(cacheTime) > EnvConfig.cacheDuration) {
      return null;
    }

    return box.get(key);
  }

  static Future<void> clearCache() async {
    final box = Hive.box(_cacheBox);
    await box.clear();
  }

  static Future<void> clearExpiredCache() async {
    final box = Hive.box(_cacheBox);
    final keys = box.keys.where((key) => key.toString().endsWith('_timestamp')).toList();

    for (final key in keys) {
      final timestamp = box.get(key);
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();

        if (now.difference(cacheTime) > EnvConfig.cacheDuration) {
          final dataKey = key.toString().replaceAll('_timestamp', '');
          await box.delete(dataKey);
          await box.delete(key);
        }
      }
    }
  }

  // Settings operations
  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> clearSettings() async {
    final box = Hive.box(_settingsBox);
    await box.clear();
  }

  // Cleanup
  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> clearAll() async {
    await Future.wait([
      Hive.box(_userBox).clear(),
      Hive.box(_bookingsBox).clear(),
      Hive.box(_destinationsBox).clear(),
      Hive.box(_flightsBox).clear(),
      Hive.box(_hotelsBox).clear(),
      Hive.box(_cacheBox).clear(),
      Hive.box(_settingsBox).clear(),
    ]);
  }
}
