import 'package:dartz/dartz.dart';

import '../entities/booking.dart';
import '../entities/flight.dart';
import '../entities/hotel.dart';
import 'base_usecase.dart';

class SearchFlightsParams {
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final FlightClass? flightClass;

  const SearchFlightsParams({
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    this.returnDate,
    this.passengers = 1,
    this.flightClass,
  });
}

class SearchHotelsParams {
  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double? maxPrice;
  final double? minRating;

  const SearchHotelsParams({
    required this.city,
    required this.checkIn,
    required this.checkOut,
    this.guests = 1,
    this.rooms = 1,
    this.maxPrice,
    this.minRating,
  });
}

class CreateBookingParams {
  final String userId;
  final BookingType type;
  final BookingItem item;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final List<String> specialRequests;

  const CreateBookingParams({
    required this.userId,
    required this.type,
    required this.item,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    this.specialRequests = const [],
  });
}

class GetBookingsParams {
  final String userId;
  final BookingStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetBookingsParams({
    required this.userId,
    this.status,
    this.startDate,
    this.endDate,
  });
}

abstract class SearchFlightsUseCase implements UseCase<List<Flight>, SearchFlightsParams> {}

abstract class SearchHotelsUseCase implements UseCase<List<Hotel>, SearchHotelsParams> {}

abstract class GetFlightDetailsUseCase implements UseCase<Flight, String> {}

abstract class GetHotelDetailsUseCase implements UseCase<Hotel, String> {}

abstract class CreateBookingUseCase implements UseCase<Booking, CreateBookingParams> {}

abstract class GetUserBookingsUseCase implements UseCase<List<Booking>, GetBookingsParams> {}

abstract class GetBookingDetailsUseCase implements UseCase<Booking, String> {}

abstract class CancelBookingUseCase implements UseCase<void, String> {}

abstract class UpdateBookingUseCase implements UseCase<Booking, Booking> {}
