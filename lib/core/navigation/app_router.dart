import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/destination/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DestinationDetailScreen(destinationId: id);
        },
      ),
      GoRoute(
        path: '/flight/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FlightDetailScreen(flightId: id);
        },
      ),
      GoRoute(
        path: '/hotel/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return HotelDetailScreen(hotelId: id);
        },
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailScreen(bookingId: id);
        },
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AIChatScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/flight-search',
        builder: (context, state) => const FlightSearchScreen(),
      ),
      GoRoute(
        path: '/hotel-search',
        builder: (context, state) => const HotelSearchScreen(),
      ),
      GoRoute(
        path: '/booking-confirmation/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingConfirmationScreen(bookingId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );

  // Navigation helpers
  static void goHome() => router.go('/');
  static void goSearch() => router.go('/search');
  static void goBookings() => router.go('/bookings');
  static void goProfile() => router.go('/profile');
  static void goLogin() => router.go('/login');
  static void goRegister() => router.go('/register');
  static void goAIChat() => router.go('/ai-chat');
  static void goSettings() => router.go('/settings');

  static void goDestination(String id) => router.go('/destination/$id');
  static void goFlight(String id) => router.go('/flight/$id');
  static void goHotel(String id) => router.go('/hotel/$id');
  static void goBooking(String id) => router.go('/booking/$id');
  static void goBookingConfirmation(String id) => router.go('/booking-confirmation/$id');

  static void goFlightSearch() => router.go('/flight-search');
  static void goHotelSearch() => router.go('/hotel-search');

  // Push methods (for modal navigation)
  static void pushDestination(BuildContext context, String id) {
    context.push('/destination/$id');
  }

  static void pushFlight(BuildContext context, String id) {
    context.push('/flight/$id');
  }

  static void pushHotel(BuildContext context, String id) {
    context.push('/hotel/$id');
  }

  static void pushBooking(BuildContext context, String id) {
    context.push('/booking/$id');
  }

  // Go back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      goHome();
    }
  }
}
