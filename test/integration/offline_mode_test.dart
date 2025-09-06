import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:travelmate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Mode Integration Tests', () {
    testWidgets('Basic offline functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login while online
      await _performLogin(tester, 'offline@example.com', 'password123');

      // Cache some data while online
      await _cacheEssentialData(tester);

      // Simulate going offline
      await _simulateOfflineMode(tester);
      await tester.pumpAndSettle();

      // Verify offline indicator
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);

      // Test cached data access
      await _testCachedDataAccess(tester);

      // Test offline booking creation
      await _testOfflineBookingCreation(tester);

      // Simulate going back online
      await _simulateOnlineMode(tester);
      await tester.pumpAndSettle();

      // Verify data sync
      await _verifyDataSync(tester);
    });

    testWidgets('Offline My Trips access', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'mytrips@example.com', 'password123');

      // Create and cache trip data
      await _createAndCacheTrips(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Navigate to My Trips
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      // Verify cached trips are visible
      expect(find.text('Seoul Adventure Package'), findsOneWidget);
      expect(find.text('Tokyo Cultural Experience'), findsOneWidget);
      expect(find.text('Cached Data'), findsOneWidget);

      // Test offline trip details access
      await tester.tap(find.text('Seoul Adventure Package'));
      await tester.pumpAndSettle();

      expect(find.text('Trip Details'), findsOneWidget);
      expect(find.text('Confirmation Number'), findsOneWidget);
      expect(find.text('Download for Offline'), findsOneWidget);

      // Test offline map access (if cached)
      await tester.tap(find.text('View Map'));
      await tester.pumpAndSettle();

      expect(find.text('Cached Map'), findsOneWidget);
    });

    testWidgets('Offline payment queue management', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'payment.offline@example.com', 'password123');

      // Go offline
      await _simulateOfflineMode(tester);

      // Attempt to make a booking (should be queued)
      await _attemptOfflineBooking(tester);

      // Verify booking is queued
      expect(find.text('Booking Queued'), findsOneWidget);
      expect(find.text('Will process when online'), findsOneWidget);

      // Check queue status
      await _checkQueueStatus(tester);
      expect(find.text('1 pending transaction'), findsOneWidget);

      // Go back online
      await _simulateOnlineMode(tester);
      await tester.pumpAndSettle();

      // Verify queue processing
      await _verifyQueueProcessing(tester);
      expect(find.text('Processing queued bookings...'), findsOneWidget);

      // Wait for processing completion
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.text('All bookings processed'), findsOneWidget);
    });

    testWidgets('Offline search with cached data', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'search.offline@example.com', 'password123');

      // Cache search data while online
      await _cacheSearchData(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Perform search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('search_field')), 'Seoul');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Verify cached results
      expect(find.text('Cached Results'), findsOneWidget);
      expect(find.text('Seoul Adventure Package'), findsOneWidget);
      expect(find.text('Seoul Business Package'), findsOneWidget);

      // Test filter functionality offline
      await tester.tap(find.byIcon(Icons.filter_alt));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Budget'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify filtered cached results
      expect(find.text('Seoul Budget Package'), findsOneWidget);
      expect(find.text('Seoul Adventure Package'), findsNothing);
    });

    testWidgets('Offline profile and settings management', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'profile.offline@example.com', 'password123');

      // Cache profile data
      await _cacheProfileData(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Navigate to profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Verify cached profile data
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('profile.offline@example.com'), findsOneWidget);

      // Test offline profile editing
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('display_name')), 'John Smith');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify changes are queued
      expect(find.text('Changes saved locally'), findsOneWidget);
      expect(find.text('Will sync when online'), findsOneWidget);

      // Test offline settings changes
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();

      // Language change should work offline
      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('Offline data synchronization conflicts', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'sync.conflict@example.com', 'password123');

      // Make changes while online
      await _makeOnlineChanges(tester);

      // Go offline and make conflicting changes
      await _simulateOfflineMode(tester);
      await _makeOfflineChanges(tester);

      // Go back online
      await _simulateOnlineMode(tester);
      await tester.pumpAndSettle();

      // Verify conflict detection
      expect(find.text('Sync Conflicts Detected'), findsOneWidget);
      expect(find.text('Choose Resolution'), findsOneWidget);

      // Test conflict resolution options
      expect(find.text('Keep Local Changes'), findsOneWidget);
      expect(find.text('Keep Server Changes'), findsOneWidget);
      expect(find.text('Merge Changes'), findsOneWidget);

      // Choose resolution
      await tester.tap(find.text('Merge Changes'));
      await tester.pumpAndSettle();

      // Verify successful resolution
      expect(find.text('Conflicts Resolved'), findsOneWidget);
    });

    testWidgets('Offline map and navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'map.offline@example.com', 'password123');

      // Download maps while online
      await _downloadOfflineMaps(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Navigate to a booking with location
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Seoul Adventure Package'));
      await tester.pumpAndSettle();

      // Access offline map
      await tester.tap(find.text('View Location'));
      await tester.pumpAndSettle();

      expect(find.text('Offline Map'), findsOneWidget);
      expect(find.byIcon(Icons.offline_bolt), findsOneWidget);

      // Test offline navigation
      await tester.tap(find.text('Get Directions'));
      await tester.pumpAndSettle();

      expect(find.text('Offline Directions'), findsOneWidget);
      expect(find.text('Based on cached data'), findsOneWidget);
    });

    testWidgets('Offline emergency information access', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'emergency.offline@example.com', 'password123');

      // Cache emergency information
      await _cacheEmergencyInfo(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Access emergency information
      await tester.tap(find.text('Emergency'));
      await tester.pumpAndSettle();

      // Verify cached emergency contacts
      expect(find.text('Emergency Contacts'), findsOneWidget);
      expect(find.text('Local Police: 112'), findsOneWidget);
      expect(find.text('Tourist Hotline: 1330'), findsOneWidget);
      expect(find.text('Embassy: +82-2-397-4114'), findsOneWidget);

      // Test emergency booking access
      await tester.tap(find.text('My Current Trip'));
      await tester.pumpAndSettle();

      expect(find.text('Seoul Grand Hotel'), findsOneWidget);
      expect(find.text('Emergency Contact: +82-2-123-4567'), findsOneWidget);
      expect(find.text('Booking Ref: TM123456'), findsOneWidget);
    });

    testWidgets('Offline storage capacity management', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'storage@example.com', 'password123');

      // Check storage usage
      await _checkStorageUsage(tester);

      // Fill up cache to near capacity
      await _fillCacheToCapacity(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Attempt to cache more data
      await _attemptAdditionalCaching(tester);

      // Verify storage management
      expect(find.text('Storage Nearly Full'), findsOneWidget);
      expect(find.text('Clear Old Data?'), findsOneWidget);

      // Accept storage cleanup
      await tester.tap(find.text('Clear Old Data'));
      await tester.pumpAndSettle();

      expect(find.text('Storage Optimized'), findsOneWidget);

      // Verify essential data is preserved
      await _verifyEssentialDataPreserved(tester);
    });

    testWidgets('Offline data integrity and validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'integrity@example.com', 'password123');

      // Cache data with checksums
      await _cacheDataWithIntegrity(tester);

      // Go offline
      await _simulateOfflineMode(tester);

      // Simulate data corruption
      await _simulateDataCorruption(tester);

      // Attempt to access corrupted data
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      // Verify integrity check
      expect(find.text('Data Integrity Check Failed'), findsOneWidget);
      expect(find.text('Restore from Backup?'), findsOneWidget);

      // Restore from backup
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();

      expect(find.text('Data Restored'), findsOneWidget);

      // Verify data is accessible again
      expect(find.text('Seoul Adventure Package'), findsOneWidget);
    });
  });

  group('Offline Performance Tests', () {
    testWidgets('Offline app launch performance', (WidgetTester tester) async {
      // Simulate offline app launch
      await _simulateOfflineLaunch(tester);

      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();

      stopwatch.stop();

      // App should launch quickly even offline
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));

      // Verify offline mode is detected
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.text('Working Offline'), findsOneWidget);
    });

    testWidgets('Large dataset offline performance', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'performance@example.com', 'password123');

      // Cache large dataset
      await _cacheLargeDataset(tester, 1000); // 1000 items

      // Go offline
      await _simulateOfflineMode(tester);

      final stopwatch = Stopwatch()..start();

      // Perform search on large dataset
      await tester.tap(find.byIcon(Icons.search));
      await tester.enterText(find.byKey(Key('search_field')), 'Seoul');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Search should be fast even with large cached dataset
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(find.text('Seoul'), findsWidgets);
    });
  });
}

// Helper methods for offline testing

Future<void> _performLogin(WidgetTester tester, String email, String password) async {
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('email_field')), email);
  await tester.enterText(find.byKey(Key('password_field')), password);
  
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle(Duration(seconds: 3));
}

Future<void> _simulateOfflineMode(WidgetTester tester) async {
  // Simulate network disconnection
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'connectivity/status',
    null,
    (data) {},
  );
  await tester.pump(Duration(milliseconds: 500));
}

Future<void> _simulateOnlineMode(WidgetTester tester) async {
  // Simulate network reconnection
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'connectivity/connected',
    null,
    (data) {},
  );
  await tester.pump(Duration(seconds: 2));
}

Future<void> _cacheEssentialData(WidgetTester tester) async {
  // Navigate through app to cache key data
  await tester.tap(find.text('My Trips'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Search'));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('search_field')), 'Seoul');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

Future<void> _testCachedDataAccess(WidgetTester tester) async {
  // Test accessing various cached data offline
  await tester.tap(find.text('My Trips'));
  await tester.pumpAndSettle();
  
  expect(find.text('Cached Data'), findsOneWidget);
  expect(find.textContaining('trip'), findsWidgets);
}

Future<void> _testOfflineBookingCreation(WidgetTester tester) async {
  // Test creating a booking offline (should be queued)
  await tester.tap(find.text('Search'));
  await tester.enterText(find.byKey(Key('search_field')), 'Seoul');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Seoul Adventure Package'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Book Now'));
  await tester.pumpAndSettle();
  
  expect(find.text('Booking will be processed when online'), findsOneWidget);
}

Future<void> _verifyDataSync(WidgetTester tester) async {
  // Verify data synchronization after coming back online
  expect(find.text('Syncing data...'), findsOneWidget);
  await tester.pumpAndSettle(Duration(seconds: 3));
  expect(find.text('Sync complete'), findsOneWidget);
}

Future<void> _createAndCacheTrips(WidgetTester tester) async {
  // Create some trips to cache
  await _createTrip(tester, 'Seoul Adventure Package');
  await _createTrip(tester, 'Tokyo Cultural Experience');
}

Future<void> _createTrip(WidgetTester tester, String tripName) async {
  await tester.tap(find.text('Search'));
  await tester.enterText(find.byKey(Key('search_field')), tripName.split(' ')[0]);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
  
  await tester.tap(find.text(tripName));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Quick Book'));
  await tester.pumpAndSettle(Duration(seconds: 2));
}

Future<void> _attemptOfflineBooking(WidgetTester tester) async {
  await tester.tap(find.text('Search'));
  await tester.enterText(find.byKey(Key('search_field')), 'Seoul');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Seoul Adventure Package'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Book Now'));
  await tester.pumpAndSettle();
  
  // Fill booking form
  await tester.enterText(find.byKey(Key('traveler_name')), 'John Doe');
  await tester.enterText(find.byKey(Key('email')), 'john@example.com');
  
  await tester.tap(find.text('Confirm Booking'));
  await tester.pumpAndSettle();
}

Future<void> _checkQueueStatus(WidgetTester tester) async {
  await tester.tap(find.text('Queue Status'));
  await tester.pumpAndSettle();
}

Future<void> _verifyQueueProcessing(WidgetTester tester) async {
  await tester.pumpAndSettle(Duration(seconds: 1));
}

Future<void> _cacheSearchData(WidgetTester tester) async {
  final searchTerms = ['Seoul', 'Tokyo', 'Busan', 'Jeju'];
  
  for (final term in searchTerms) {
    await tester.tap(find.text('Search'));
    await tester.enterText(find.byKey(Key('search_field')), term);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    
    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }
}

Future<void> _cacheProfileData(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  
  // Access various profile sections to cache data
  await tester.tap(find.text('Travel Preferences'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Payment Methods'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
}

Future<void> _makeOnlineChanges(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Edit'));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('display_name')), 'John Online');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

Future<void> _makeOfflineChanges(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Edit'));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('display_name')), 'John Offline');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

Future<void> _downloadOfflineMaps(WidgetTester tester) async {
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Offline Maps'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Download Seoul Map'));
  await tester.pumpAndSettle(Duration(seconds: 5));
  
  expect(find.text('Download Complete'), findsOneWidget);
}

Future<void> _cacheEmergencyInfo(WidgetTester tester) async {
  await tester.tap(find.text('Emergency'));
  await tester.pumpAndSettle();
  
  // Cache emergency contacts and info
  await tester.tap(find.text('Local Contacts'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Embassy Info'));
  await tester.pumpAndSettle();
}

Future<void> _checkStorageUsage(WidgetTester tester) async {
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Storage'));
  await tester.pumpAndSettle();
  
  expect(find.textContaining('MB used'), findsOneWidget);
}

Future<void> _fillCacheToCapacity(WidgetTester tester) async {
  // Simulate filling cache by downloading lots of data
  for (int i = 0; i < 50; i++) {
    await tester.tap(find.text('Cache More Data'));
    await tester.pump(Duration(milliseconds: 100));
  }
}

Future<void> _attemptAdditionalCaching(WidgetTester tester) async {
  await tester.tap(find.text('Download Large File'));
  await tester.pumpAndSettle();
}

Future<void> _verifyEssentialDataPreserved(WidgetTester tester) async {
  await tester.tap(find.text('My Trips'));
  await tester.pumpAndSettle();
  
  // Essential trip data should still be available
  expect(find.textContaining('trip'), findsWidgets);
}

Future<void> _cacheDataWithIntegrity(WidgetTester tester) async {
  // Cache data with integrity checks enabled
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Data Integrity'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.switchWithSemanticsLabel('Enable Checksums'));
  await tester.pumpAndSettle();
}

Future<void> _simulateDataCorruption(WidgetTester tester) async {
  // Simulate data corruption (in real implementation, this would corrupt cache files)
  await tester.pump(Duration(milliseconds: 100));
}

Future<void> _simulateOfflineLaunch(WidgetTester tester) async {
  // Simulate app launch in offline mode
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'connectivity/offline_launch',
    null,
    (data) {},
  );
}

Future<void> _cacheLargeDataset(WidgetTester tester, int itemCount) async {
  // Simulate caching a large dataset
  for (int i = 0; i < itemCount ~/ 100; i++) {
    await tester.pump(Duration(milliseconds: 50));
  }
}

Future<void> _testMemoryUsageStability(WidgetTester tester) async {
  // Test that memory usage remains stable during long offline sessions
  for (int i = 0; i < 100; i++) {
    await tester.tap(find.text('My Trips'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    
    if (i % 10 == 0) {
      // Simulate garbage collection checkpoint
      await tester.pump(Duration(milliseconds: 500));
    }
  }
}