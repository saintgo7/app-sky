import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserType { individual, corporate, government }
enum UserRole { user, groupAdmin, admin, superAdmin }

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final UserType userType;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Corporate/Government specific fields
  final String? companyName;
  final String? businessNumber;
  final String? department;
  final String? position;
  final List<String>? managedGroupIds;
  
  // Preferences
  final UserPreferences? preferences;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.userType,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.companyName,
    this.businessNumber,
    this.department,
    this.position,
    this.managedGroupIds,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    UserType? userType,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? companyName,
    String? businessNumber,
    String? department,
    String? position,
    List<String>? managedGroupIds,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyName: companyName ?? this.companyName,
      businessNumber: businessNumber ?? this.businessNumber,
      department: department ?? this.department,
      position: position ?? this.position,
      managedGroupIds: managedGroupIds ?? this.managedGroupIds,
      preferences: preferences ?? this.preferences,
    );
  }
}

@JsonSerializable()
class UserPreferences {
  final String? preferredLanguage;
  final String? preferredCurrency;
  final List<String>? favoriteDestinations;
  final TravelPreferences? travelPreferences;
  final NotificationSettings? notificationSettings;

  const UserPreferences({
    this.preferredLanguage,
    this.preferredCurrency,
    this.favoriteDestinations,
    this.travelPreferences,
    this.notificationSettings,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

@JsonSerializable()
class TravelPreferences {
  final List<String>? accommodationTypes;
  final List<String>? mealTypes;
  final String? budgetRange;
  final List<String>? activities;
  final bool? includeFlights;
  final bool? includeInsurance;

  const TravelPreferences({
    this.accommodationTypes,
    this.mealTypes,
    this.budgetRange,
    this.activities,
    this.includeFlights,
    this.includeInsurance,
  });

  factory TravelPreferences.fromJson(Map<String, dynamic> json) => _$TravelPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$TravelPreferencesToJson(this);
}

@JsonSerializable()
class NotificationSettings {
  final bool bookingUpdates;
  final bool promotions;
  final bool groupInvitations;
  final bool paymentReminders;

  const NotificationSettings({
    required this.bookingUpdates,
    required this.promotions,
    required this.groupInvitations,
    required this.paymentReminders,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}