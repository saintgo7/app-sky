# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

스카이 항공(Sky Air)은 Flutter 기반 AI 항공권 예약 및 여행 서비스 플랫폼입니다. HyperCLOVA X SEED를 활용한 AI 여행 상담 기능을 제공합니다.

## Development Commands

### Setup
```bash
flutter pub get                    # Install dependencies
```

### Running the App
```bash
flutter run                       # Run in development mode
flutter run --release             # Run in release mode
```

### Code Quality
```bash
flutter analyze                   # Run static analysis
flutter format .                  # Format code
```

### Testing
```bash
flutter test                      # Run all tests
```

## Architecture

```
lib/
├── main.dart                     # 앱 진입점 (SkyAirApp)
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # 색상 상수
│   │   └── app_strings.dart      # 문자열 상수
│   └── themes/
│       └── app_theme.dart        # UI 테마
├── services/
│   └── ai/
│       └── hyperclova_service.dart  # HyperCLOVA X AI 서비스
└── presentation/
    └── screens/
        └── ai_chat_screen.dart   # AI 채팅 화면
```

## Key Technologies

- **Framework**: Flutter 3.8+
- **AI**: HyperCLOVA X SEED (Naver AI)
- **HTTP Client**: Dio

## Internationalization

4개 언어 지원 (l10n/ 폴더):
- 한국어 (ko)
- 영어 (en)
- 중국어 (zh)
- 일본어 (ja)

## Important Notes

- Main entry point is `lib/main.dart` which runs `SkyAirApp`
- AI chat functionality uses `HyperClovaService` for travel consultation
- The app targets desktop-first design with responsive layouts
