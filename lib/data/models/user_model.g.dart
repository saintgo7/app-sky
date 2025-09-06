// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      companyName: json['companyName'] as String?,
      businessNumber: json['businessNumber'] as String?,
      department: json['department'] as String?,
      position: json['position'] as String?,
      managedGroupIds: (json['managedGroupIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferences: json['preferences'] == null
          ? null
          : UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'companyName': instance.companyName,
      'businessNumber': instance.businessNumber,
      'department': instance.department,
      'position': instance.position,
      'managedGroupIds': instance.managedGroupIds,
      'preferences': instance.preferences,
    };

const _$UserTypeEnumMap = {
  UserType.individual: 'individual',
  UserType.corporate: 'corporate',
  UserType.government: 'government',
};

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.groupAdmin: 'groupAdmin',
  UserRole.admin: 'admin',
  UserRole.superAdmin: 'superAdmin',
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      preferredLanguage: json['preferredLanguage'] as String?,
      preferredCurrency: json['preferredCurrency'] as String?,
      favoriteDestinations: (json['favoriteDestinations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      travelPreferences: json['travelPreferences'] == null
          ? null
          : TravelPreferences.fromJson(
              json['travelPreferences'] as Map<String, dynamic>),
      notificationSettings: json['notificationSettings'] == null
          ? null
          : NotificationSettings.fromJson(
              json['notificationSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'preferredLanguage': instance.preferredLanguage,
      'preferredCurrency': instance.preferredCurrency,
      'favoriteDestinations': instance.favoriteDestinations,
      'travelPreferences': instance.travelPreferences,
      'notificationSettings': instance.notificationSettings,
    };

TravelPreferences _$TravelPreferencesFromJson(Map<String, dynamic> json) =>
    TravelPreferences(
      accommodationTypes: (json['accommodationTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mealTypes: (json['mealTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      budgetRange: json['budgetRange'] as String?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      includeFlights: json['includeFlights'] as bool?,
      includeInsurance: json['includeInsurance'] as bool?,
    );

Map<String, dynamic> _$TravelPreferencesToJson(TravelPreferences instance) =>
    <String, dynamic>{
      'accommodationTypes': instance.accommodationTypes,
      'mealTypes': instance.mealTypes,
      'budgetRange': instance.budgetRange,
      'activities': instance.activities,
      'includeFlights': instance.includeFlights,
      'includeInsurance': instance.includeInsurance,
    };

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationSettings(
      bookingUpdates: json['bookingUpdates'] as bool,
      promotions: json['promotions'] as bool,
      groupInvitations: json['groupInvitations'] as bool,
      paymentReminders: json['paymentReminders'] as bool,
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'bookingUpdates': instance.bookingUpdates,
      'promotions': instance.promotions,
      'groupInvitations': instance.groupInvitations,
      'paymentReminders': instance.paymentReminders,
    };
