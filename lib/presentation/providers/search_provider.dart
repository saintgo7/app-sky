import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/hotel.dart';

// Search State
class SearchState {
  final String query;
  final List<Destination> destinations;
  final List<Flight> flights;
  final List<Hotel> hotels;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final Map<String, dynamic> filters;

  const SearchState({
    this.query = '',
    this.destinations = const [],
    this.flights = const [],
    this.hotels = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.filters = const {},
  });

  SearchState copyWith({
    String? query,
    List<Destination>? destinations,
    List<Flight>? flights,
    List<Hotel>? hotels,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    Map<String, dynamic>? filters,
  }) {
    return SearchState(
      query: query ?? this.query,
      destinations: destinations ?? this.destinations,
      flights: flights ?? this.flights,
      hotels: hotels ?? this.hotels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      filters: filters ?? this.filters,
    );
  }
}

// Search Notifier
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Mock data for demonstration
    final destinations = [
      const Destination(
        id: '1',
        name: '서울',
        country: '대한민국',
        city: '서울',
        description: '한국의 수도, 현대적인 도시와 전통이 공존하는 매력적인 도시',
        images: ['https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400'],
        latitude: 37.5665,
        longitude: 126.9780,
        currency: 'KRW',
        language: 'ko',
        rating: 4.8,
        reviewCount: 1250,
      ),
      const Destination(
        id: '2',
        name: '도쿄',
        country: '일본',
        city: '도쿄',
        description: '현대적인 대도시와 전통 사무라이 문화가 공존하는 일본의 수도',
        images: ['https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400'],
        latitude: 35.6762,
        longitude: 139.6503,
        currency: 'JPY',
        language: 'ja',
        rating: 4.9,
        reviewCount: 2100,
      ),
    ];

    state = state.copyWith(destinations: destinations);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _loadInitialData();
      return;
    }

    state = state.copyWith(isLoading: true, query: query, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock search results
      final filteredDestinations = state.destinations
          .where((dest) =>
              dest.name.toLowerCase().contains(query.toLowerCase()) ||
              dest.country.toLowerCase().contains(query.toLowerCase()) ||
              dest.city.toLowerCase().contains(query.toLowerCase()))
          .toList();

      state = state.copyWith(
        destinations: filteredDestinations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchFlights({
    required String departureCity,
    required String arrivalCity,
    required DateTime departureDate,
    DateTime? returnDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock flight results
      final mockFlights = [
        Flight(
          id: 'flight_1',
          flightNumber: 'KE123',
          airline: const Airline(
            id: 'ke',
            name: '대한항공',
            iataCode: 'KE',
            icaoCode: 'KAL',
            logoUrl: '',
            country: '대한민국',
            rating: 4.5,
          ),
          departureAirport: Airport(
            id: 'icn',
            name: '인천 국제공항',
            iataCode: 'ICN',
            icaoCode: 'RKSI',
            city: '인천',
            country: '대한민국',
            latitude: 37.4691,
            longitude: 126.4505,
            timezone: 'Asia/Seoul',
          ),
          arrivalAirport: Airport(
            id: 'nrt',
            name: '나리타 국제공항',
            iataCode: 'NRT',
            icaoCode: 'RJAA',
            city: '도쿄',
            country: '일본',
            latitude: 35.7720,
            longitude: 140.3929,
            timezone: 'Asia/Tokyo',
          ),
          departureTime: DateTime.now().add(const Duration(hours: 2)),
          arrivalTime: DateTime.now().add(const Duration(hours: 4, minutes: 15)),
          duration: const Duration(hours: 2, minutes: 15),
          flightClass: FlightClass.economy,
          price: 150000,
          currency: 'KRW',
          availableSeats: 45,
          amenities: ['Wi-Fi', '식사', '엔터테인먼트'],
        ),
      ];

      state = state.copyWith(
        flights: mockFlights,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchHotels({
    required String city,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock hotel results
      final mockHotels = [
        Hotel(
          id: 'hotel_1',
          name: '신라호텔 서울',
          description: '서울의 중심에 위치한 5성급 럭셔리 호텔',
          images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'],
          latitude: 37.5665,
          longitude: 126.9780,
          address: '서울 중구 동호로 249',
          city: '서울',
          country: '대한민국',
          postalCode: '04533',
          rating: HotelRating.luxury,
          starRating: 5.0,
          reviewCount: 850,
          amenities: ['스파', '피트니스', '룸서비스', '와이파이'],
          contactInfo: const ContactInfo(
            phone: '+82-2-2230-3310',
            email: 'info@shillahotels.com',
            website: 'https://www.shillahotels.com',
          ),
          distanceFromCenter: 2.5,
        ),
      ];

      state = state.copyWith(
        hotels: mockHotels,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    state = state.copyWith(filters: {...state.filters, ...newFilters});
  }

  void clearFilters() {
    state = state.copyWith(filters: {});
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Search Provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

// Search Selectors
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(searchProvider).query;
});

final searchDestinationsProvider = Provider<List<Destination>>((ref) {
  return ref.watch(searchProvider).destinations;
});

final searchFlightsProvider = Provider<List<Flight>>((ref) {
  return ref.watch(searchProvider).flights;
});

final searchHotelsProvider = Provider<List<Hotel>>((ref) {
  return ref.watch(searchProvider).hotels;
});

final searchIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(searchProvider).isLoading;
});

final searchErrorProvider = Provider<String?>((ref) {
  return ref.watch(searchProvider).error;
});

final searchSelectedCategoryProvider = Provider<String?>((ref) {
  return ref.watch(searchProvider).selectedCategory;
});
