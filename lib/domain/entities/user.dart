class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isEmailVerified;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.isEmailVerified = false,
    this.role = UserRole.customer,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    bool? isEmailVerified,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
    );
  }
}

enum UserRole {
  customer,
  admin,
  agent,
}

class UserPreferences {
  final List<String> favoriteDestinations;
  final List<String> preferredAirlines;
  final List<String> preferredHotelChains;
  final int budgetRange;
  final List<String> travelStyles;
  final bool notificationsEnabled;

  const UserPreferences({
    this.favoriteDestinations = const [],
    this.preferredAirlines = const [],
    this.preferredHotelChains = const [],
    this.budgetRange = 2000000, // 2백만원 기본
    this.travelStyles = const [],
    this.notificationsEnabled = true,
  });

  UserPreferences copyWith({
    List<String>? favoriteDestinations,
    List<String>? preferredAirlines,
    List<String>? preferredHotelChains,
    int? budgetRange,
    List<String>? travelStyles,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      favoriteDestinations: favoriteDestinations ?? this.favoriteDestinations,
      preferredAirlines: preferredAirlines ?? this.preferredAirlines,
      preferredHotelChains: preferredHotelChains ?? this.preferredHotelChains,
      budgetRange: budgetRange ?? this.budgetRange,
      travelStyles: travelStyles ?? this.travelStyles,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
