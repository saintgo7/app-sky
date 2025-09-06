# Presentation 폴더

사용자 인터페이스와 상태 관리를 담당하는 폴더입니다.

## 하위 폴더 구조

### screens/
- 전체 화면 단위의 위젯들
- 각 화면별로 폴더를 구성하여 관리
- 예: `home/`, `booking/`, `profile/`, `search/`

### widgets/
- 재사용 가능한 UI 컴포넌트들
- 공통으로 사용되는 커스텀 위젯
- 예: `custom_button.dart`, `destination_card.dart`, `loading_widget.dart`

### providers/
- 상태 관리를 위한 Provider 클래스들
- Riverpod을 이용한 전역 상태 관리
- 예: `auth_provider.dart`, `booking_provider.dart`, `theme_provider.dart`

## 화면별 폴더 구조 예시
```
screens/
├── home/
│   ├── home_screen.dart
│   ├── widgets/
│   └── providers/
├── booking/
│   ├── booking_screen.dart
│   ├── booking_detail_screen.dart
│   └── widgets/
└── profile/
    ├── profile_screen.dart
    └── settings_screen.dart
```

## 설계 원칙
- UI와 비즈니스 로직 분리
- 재사용 가능한 컴포넌트 설계
- 반응형 UI 구현