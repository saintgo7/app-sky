class Booking {
  final String id;
  final String userId;
  final BookingType type;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final double totalAmount;
  final String currency;
  final PaymentInfo paymentInfo;
  final List<Traveler> travelers;
  final ContactPerson contactPerson;
  final BookingItem item;
  final List<String> specialRequests;
  final Map<String, dynamic> metadata;
  final List<BookingUpdate> updates;

  const Booking({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    required this.totalAmount,
    required this.currency,
    required this.paymentInfo,
    required this.travelers,
    required this.contactPerson,
    required this.item,
    this.specialRequests = const [],
    this.metadata = const {},
    this.updates = const [],
  });

  Duration get duration => checkOutDate.difference(checkInDate);

  bool get isUpcoming => checkInDate.isAfter(DateTime.now());
  bool get isOngoing => checkInDate.isBefore(DateTime.now()) && checkOutDate.isAfter(DateTime.now());
  bool get isCompleted => checkOutDate.isBefore(DateTime.now());

  double get amountPerPerson => guestCount > 0 ? totalAmount / guestCount : 0.0;

  Booking copyWith({
    String? id,
    String? userId,
    BookingType? type,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guestCount,
    double? totalAmount,
    String? currency,
    PaymentInfo? paymentInfo,
    List<Traveler>? travelers,
    ContactPerson? contactPerson,
    BookingItem? item,
    List<String>? specialRequests,
    Map<String, dynamic>? metadata,
    List<BookingUpdate>? updates,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guestCount: guestCount ?? this.guestCount,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      travelers: travelers ?? this.travelers,
      contactPerson: contactPerson ?? this.contactPerson,
      item: item ?? this.item,
      specialRequests: specialRequests ?? this.specialRequests,
      metadata: metadata ?? this.metadata,
      updates: updates ?? this.updates,
    );
  }
}

class BookingItem {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final Map<String, dynamic> details;

  const BookingItem({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.details,
  });
}

class Traveler {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String nationality;
  final String passportNumber;
  final DateTime passportExpiry;
  final String? specialRequests;

  const Traveler({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.nationality,
    required this.passportNumber,
    required this.passportExpiry,
    this.specialRequests,
  });

  String get fullName => '$firstName $lastName';
}

class ContactPerson {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String country;

  const ContactPerson({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
  });

  String get fullName => '$firstName $lastName';
}

class PaymentInfo {
  final String id;
  final String method;
  final String status;
  final double amount;
  final String currency;
  final DateTime paidAt;
  final String? transactionId;
  final Map<String, dynamic> details;

  const PaymentInfo({
    required this.id,
    required this.method,
    required this.status,
    required this.amount,
    required this.currency,
    required this.paidAt,
    this.transactionId,
    this.details = const {},
  });
}

class BookingUpdate {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final BookingUpdateType type;
  final Map<String, dynamic> metadata;

  const BookingUpdate({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.metadata = const {},
  });
}

enum BookingType {
  flight,
  hotel,
  package,
  activity,
  carRental,
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  refunded,
  failed,
}

enum BookingUpdateType {
  confirmation,
  modification,
  cancellation,
  reminder,
  statusUpdate,
  payment,
}
