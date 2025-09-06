# Domain 폴더

비즈니스 로직과 도메인 규칙을 정의하는 폴더입니다. 가장 순수한 계층으로 외부 의존성이 없어야 합니다.

## 하위 폴더 구조

### entities/
- 비즈니스 도메인의 핵심 객체들
- 순수한 Dart 클래스로 구성
- 예: `destination.dart`, `trip.dart`, `user.dart`, `booking.dart`

### usecases/
- 특정 비즈니스 기능을 수행하는 유스케이스
- 하나의 유스케이스는 하나의 기능만 담당
- 예: `search_destinations.dart`, `book_trip.dart`, `get_user_bookings.dart`

## 핵심 원칙
- Framework에 독립적
- 데이터베이스나 UI에 의존하지 않음
- 순수한 비즈니스 로직만 포함
- 테스트하기 쉬운 구조

## 예시 구조
```
entities/
  ├── destination.dart
  ├── trip.dart
  ├── user.dart
  └── booking.dart

usecases/
  ├── search_destinations_usecase.dart
  ├── book_trip_usecase.dart
  └── get_user_bookings_usecase.dart
```