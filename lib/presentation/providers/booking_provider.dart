import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/booking.dart';

// Booking State
class BookingState {
  final List<Booking> bookings;
  final Booking? selectedBooking;
  final bool isLoading;
  final String? error;
  final BookingStatus? filterStatus;

  const BookingState({
    this.bookings = const [],
    this.selectedBooking,
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  BookingState copyWith({
    List<Booking>? bookings,
    Booking? selectedBooking,
    bool? isLoading,
    String? error,
    BookingStatus? filterStatus,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      selectedBooking: selectedBooking ?? this.selectedBooking,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  List<Booking> get upcomingBookings =>
      bookings.where((booking) => booking.isUpcoming).toList();

  List<Booking> get ongoingBookings =>
      bookings.where((booking) => booking.isOngoing).toList();

  List<Booking> get completedBookings =>
      bookings.where((booking) => booking.isCompleted).toList();

  List<Booking> get filteredBookings {
    if (filterStatus == null) return bookings;
    return bookings.where((booking) => booking.status == filterStatus).toList();
  }
}

// Booking Notifier
class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState()) {
    _loadMockBookings();
  }

  void _loadMockBookings() {
    // Mock booking data
    final mockBookings = [
      Booking(
        id: 'booking_1',
        userId: '1',
        type: BookingType.flight,
        status: BookingStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        checkInDate: DateTime.now().add(const Duration(days: 15)),
        checkOutDate: DateTime.now().add(const Duration(days: 15)),
        guestCount: 1,
        totalAmount: 150000,
        currency: 'KRW',
        paymentInfo: PaymentInfo(
          id: 'payment_1',
          method: 'credit_card',
          status: 'paid',
          amount: 150000,
          currency: 'KRW',
          paidAt: DateTime.now().subtract(const Duration(days: 5)),
          transactionId: 'txn_123456',
        ),
        travelers: [
          const Traveler(
            id: 'traveler_1',
            firstName: '철수',
            lastName: '김',
            email: 'chulsoo@example.com',
            phoneNumber: '+82-10-1234-5678',
            dateOfBirth: DateTime(1990, 1, 1),
            nationality: '대한민국',
            passportNumber: 'M123456789',
            passportExpiry: DateTime(2030, 12, 31),
          ),
        ],
        contactPerson: const ContactPerson(
          firstName: '철수',
          lastName: '김',
          email: 'chulsoo@example.com',
          phoneNumber: '+82-10-1234-5678',
          country: '대한민국',
        ),
        item: const BookingItem(
          id: 'flight_ke123',
          name: '대한항공 KE123',
          description: '서울 → 도쿄 직항편',
          images: ['https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400'],
          details: {'flightNumber': 'KE123', 'airline': '대한항공'},
        ),
      ),
      Booking(
        id: 'booking_2',
        userId: '1',
        type: BookingType.hotel,
        status: BookingStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        checkInDate: DateTime.now().add(const Duration(days: 15)),
        checkOutDate: DateTime.now().add(const Duration(days: 17)),
        guestCount: 1,
        totalAmount: 350000,
        currency: 'KRW',
        paymentInfo: PaymentInfo(
          id: 'payment_2',
          method: 'credit_card',
          status: 'paid',
          amount: 350000,
          currency: 'KRW',
          paidAt: DateTime.now().subtract(const Duration(days: 10)),
          transactionId: 'txn_789012',
        ),
        travelers: [
          const Traveler(
            id: 'traveler_1',
            firstName: '철수',
            lastName: '김',
            email: 'chulsoo@example.com',
            phoneNumber: '+82-10-1234-5678',
            dateOfBirth: DateTime(1990, 1, 1),
            nationality: '대한민국',
            passportNumber: 'M123456789',
            passportExpiry: DateTime(2030, 12, 31),
          ),
        ],
        contactPerson: const ContactPerson(
          firstName: '철수',
          lastName: '김',
          email: 'chulsoo@example.com',
          phoneNumber: '+82-10-1234-5678',
          country: '대한민국',
        ),
        item: const BookingItem(
          id: 'hotel_shillaseoul',
          name: '신라호텔 서울',
          description: '서울 중구에 위치한 5성급 호텔',
          images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'],
          details: {'stars': 5, 'location': '서울 중구'},
        ),
      ),
      Booking(
        id: 'booking_3',
        userId: '1',
        type: BookingType.flight,
        status: BookingStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 25)),
        checkInDate: DateTime.now().subtract(const Duration(days: 25)),
        checkOutDate: DateTime.now().subtract(const Duration(days: 25)),
        guestCount: 1,
        totalAmount: 200000,
        currency: 'KRW',
        paymentInfo: PaymentInfo(
          id: 'payment_3',
          method: 'credit_card',
          status: 'paid',
          amount: 200000,
          currency: 'KRW',
          paidAt: DateTime.now().subtract(const Duration(days: 30)),
          transactionId: 'txn_345678',
        ),
        travelers: [
          const Traveler(
            id: 'traveler_1',
            firstName: '철수',
            lastName: '김',
            email: 'chulsoo@example.com',
            phoneNumber: '+82-10-1234-5678',
            dateOfBirth: DateTime(1990, 1, 1),
            nationality: '대한민국',
            passportNumber: 'M123456789',
            passportExpiry: DateTime(2030, 12, 31),
          ),
        ],
        contactPerson: const ContactPerson(
          firstName: '철수',
          lastName: '김',
          email: 'chulsoo@example.com',
          phoneNumber: '+82-10-1234-5678',
          country: '대한민국',
        ),
        item: const BookingItem(
          id: 'flight_oz777',
          name: '아시아나항공 OZ777',
          description: '서울 → 방콕 직항편',
          images: ['https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400'],
          details: {'flightNumber': 'OZ777', 'airline': '아시아나항공'},
        ),
      ),
    ];

    state = state.copyWith(bookings: mockBookings);
  }

  Future<void> loadBookings({String? userId, BookingStatus? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would fetch from API
      // For now, we just use the mock data that's already loaded

      state = state.copyWith(
        isLoading: false,
        filterStatus: status,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createBooking(Booking booking) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Add new booking to the list
      final updatedBookings = [...state.bookings, booking];
      state = state.copyWith(
        bookings: updatedBookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(status: BookingStatus.cancelled);
        }
        return booking;
      }).toList();

      state = state.copyWith(
        bookings: updatedBookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectBooking(String bookingId) {
    final booking = state.bookings.firstWhere(
      (b) => b.id == bookingId,
    );
    state = state.copyWith(selectedBooking: booking);
  }

  void clearSelection() {
    state = state.copyWith(selectedBooking: null);
  }

  void setFilter(BookingStatus? status) {
    state = state.copyWith(filterStatus: status);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Booking Provider
final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

// Booking Selectors
final bookingsProvider = Provider<List<Booking>>((ref) {
  return ref.watch(bookingProvider).bookings;
});

final upcomingBookingsProvider = Provider<List<Booking>>((ref) {
  return ref.watch(bookingProvider).upcomingBookings;
});

final ongoingBookingsProvider = Provider<List<Booking>>((ref) {
  return ref.watch(bookingProvider).ongoingBookings;
});

final completedBookingsProvider = Provider<List<Booking>>((ref) {
  return ref.watch(bookingProvider).completedBookings;
});

final selectedBookingProvider = Provider<Booking?>((ref) {
  return ref.watch(bookingProvider).selectedBooking;
});

final bookingIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(bookingProvider).isLoading;
});

final bookingErrorProvider = Provider<String?>((ref) {
  return ref.watch(bookingProvider).error;
});
