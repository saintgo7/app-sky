import 'package:flutter_test/flutter_test.dart';
import 'package:travelmate/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    late UserModel testUser;
    late DateTime testDateTime;
    
    setUp(() {
      testDateTime = DateTime(2024, 1, 1);
      testUser = UserModel(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        phone: '+1234567890',
        profileImage: 'https://example.com/profile.jpg',
        userType: UserType.individual,
        role: UserRole.user,
        isActive: true,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );
    });

    test('should create UserModel with required fields', () {
      expect(testUser.id, 'user123');
      expect(testUser.email, 'test@example.com');
      expect(testUser.name, 'Test User');
      expect(testUser.userType, UserType.individual);
      expect(testUser.role, UserRole.user);
      expect(testUser.isActive, isTrue);
    });

    test('should serialize and deserialize to/from JSON correctly', () {
      final json = testUser.toJson();
      final deserializedUser = UserModel.fromJson(json);
      
      expect(deserializedUser.id, testUser.id);
      expect(deserializedUser.email, testUser.email);
      expect(deserializedUser.name, testUser.name);
      expect(deserializedUser.userType, testUser.userType);
      expect(deserializedUser.role, testUser.role);
      expect(deserializedUser.isActive, testUser.isActive);
    });

    test('should create UserModel with corporate fields', () {
      final corporateUser = UserModel(
        id: 'corp123',
        email: 'admin@company.com',
        name: 'Corporate Admin',
        userType: UserType.corporate,
        role: UserRole.groupAdmin,
        isActive: true,
        createdAt: testDateTime,
        updatedAt: testDateTime,
        companyName: 'Test Company',
        businessNumber: '123-456-789',
        department: 'IT',
        position: 'Manager',
        managedGroupIds: ['group1', 'group2'],
      );

      expect(corporateUser.companyName, 'Test Company');
      expect(corporateUser.businessNumber, '123-456-789');
      expect(corporateUser.department, 'IT');
      expect(corporateUser.position, 'Manager');
      expect(corporateUser.managedGroupIds, ['group1', 'group2']);
    });

    test('should copyWith create new instance with updated fields', () {
      final updatedUser = testUser.copyWith(
        name: 'Updated Name',
        isActive: false,
      );

      expect(updatedUser.id, testUser.id);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.isActive, isFalse);
      expect(updatedUser.email, testUser.email);
    });

    test('should handle UserPreferences correctly', () {
      final preferences = UserPreferences(
        preferredLanguage: 'ko',
        preferredCurrency: 'KRW',
        favoriteDestinations: ['Seoul', 'Tokyo'],
        travelPreferences: TravelPreferences(
          accommodationTypes: ['hotel', 'resort'],
          mealTypes: ['breakfast', 'dinner'],
          budgetRange: '1000-5000',
          activities: ['sightseeing', 'shopping'],
          includeFlights: true,
          includeInsurance: true,
        ),
        notificationSettings: NotificationSettings(
          bookingUpdates: true,
          promotions: false,
          groupInvitations: true,
          paymentReminders: true,
        ),
      );

      final userWithPreferences = testUser.copyWith(preferences: preferences);
      
      expect(userWithPreferences.preferences?.preferredLanguage, 'ko');
      expect(userWithPreferences.preferences?.preferredCurrency, 'KRW');
      expect(userWithPreferences.preferences?.favoriteDestinations, ['Seoul', 'Tokyo']);
      expect(userWithPreferences.preferences?.travelPreferences?.budgetRange, '1000-5000');
      expect(userWithPreferences.preferences?.notificationSettings?.bookingUpdates, isTrue);
    });
  });

  group('UserType Tests', () {
    test('should have correct enum values', () {
      expect(UserType.values.length, 3);
      expect(UserType.values, [UserType.individual, UserType.corporate, UserType.government]);
    });
  });

  group('UserRole Tests', () {
    test('should have correct enum values', () {
      expect(UserRole.values.length, 4);
      expect(UserRole.values, [UserRole.user, UserRole.groupAdmin, UserRole.admin, UserRole.superAdmin]);
    });
  });

  group('TravelPreferences Tests', () {
    test('should serialize and deserialize correctly', () {
      final preferences = TravelPreferences(
        accommodationTypes: ['hotel'],
        mealTypes: ['breakfast'],
        budgetRange: '1000-2000',
        activities: ['sightseeing'],
        includeFlights: true,
        includeInsurance: false,
      );

      final json = preferences.toJson();
      final deserialized = TravelPreferences.fromJson(json);

      expect(deserialized.accommodationTypes, preferences.accommodationTypes);
      expect(deserialized.budgetRange, preferences.budgetRange);
      expect(deserialized.includeFlights, preferences.includeFlights);
      expect(deserialized.includeInsurance, preferences.includeInsurance);
    });
  });

  group('NotificationSettings Tests', () {
    test('should handle all boolean flags correctly', () {
      final settings = NotificationSettings(
        bookingUpdates: true,
        promotions: false,
        groupInvitations: true,
        paymentReminders: false,
      );

      final json = settings.toJson();
      final deserialized = NotificationSettings.fromJson(json);

      expect(deserialized.bookingUpdates, isTrue);
      expect(deserialized.promotions, isFalse);
      expect(deserialized.groupInvitations, isTrue);
      expect(deserialized.paymentReminders, isFalse);
    });
  });
}