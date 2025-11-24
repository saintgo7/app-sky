class Flight {
  final String id;
  final String flightNumber;
  final Airline airline;
  final Airport departureAirport;
  final Airport arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final Duration duration;
  final FlightClass flightClass;
  final double price;
  final String currency;
  final int availableSeats;
  final List<String> amenities;
  final FlightStatus status;
  final bool isDirect;
  final List<FlightStop>? stops;

  const Flight({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.flightClass,
    required this.price,
    required this.currency,
    required this.availableSeats,
    this.amenities = const [],
    this.status = FlightStatus.scheduled,
    this.isDirect = true,
    this.stops,
  });

  Duration get flightDuration => arrivalTime.difference(departureTime);

  bool get isFull => availableSeats == 0;

  Flight copyWith({
    String? id,
    String? flightNumber,
    Airline? airline,
    Airport? departureAirport,
    Airport? arrivalAirport,
    DateTime? departureTime,
    DateTime? arrivalTime,
    Duration? duration,
    FlightClass? flightClass,
    double? price,
    String? currency,
    int? availableSeats,
    List<String>? amenities,
    FlightStatus? status,
    bool? isDirect,
    List<FlightStop>? stops,
  }) {
    return Flight(
      id: id ?? this.id,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      duration: duration ?? this.duration,
      flightClass: flightClass ?? this.flightClass,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      availableSeats: availableSeats ?? this.availableSeats,
      amenities: amenities ?? this.amenities,
      status: status ?? this.status,
      isDirect: isDirect ?? this.isDirect,
      stops: stops ?? this.stops,
    );
  }
}

class Airline {
  final String id;
  final String name;
  final String iataCode;
  final String icaoCode;
  final String logoUrl;
  final String country;
  final double rating;

  const Airline({
    required this.id,
    required this.name,
    required this.iataCode,
    required this.icaoCode,
    required this.logoUrl,
    required this.country,
    this.rating = 0.0,
  });
}

class Airport {
  final String id;
  final String name;
  final String iataCode;
  final String icaoCode;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;

  const Airport({
    required this.id,
    required this.name,
    required this.iataCode,
    required this.icaoCode,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });
}

class FlightStop {
  final Airport airport;
  final Duration layoverDuration;
  final DateTime arrivalTime;
  final DateTime departureTime;

  const FlightStop({
    required this.airport,
    required this.layoverDuration,
    required this.arrivalTime,
    required this.departureTime,
  });
}

enum FlightClass {
  economy,
  premiumEconomy,
  business,
  first,
}

enum FlightStatus {
  scheduled,
  onTime,
  delayed,
  cancelled,
  departed,
  arrived,
}
