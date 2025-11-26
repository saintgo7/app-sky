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

## Architecture

```
lib/
├── core/              # 앱 핵심 기능 (상수, 테마, 유틸리티)
│   ├── constants/     # 앱 상수 (문자열, 색상)
│   ├── themes/        # UI 테마
│   ├── error/         # 에러 처리
│   ├── network/       # 네트워크 유틸리티
│   └── environment/   # 환경 설정
├── services/          # 외부 서비스
│   └── ai/            # AI 서비스 (HyperCLOVA)
├── presentation/      # UI 계층
│   └── screens/       # 화면 위젯
└── main.dart          # 앱 진입점
```

## Key Technologies

- **Framework**: Flutter 3.8+
- **AI**: HyperCLOVA X SEED (Naver AI)
- **State Management**: Provider

## Environment Configuration

The app supports three environments with separate configuration files:
- `.env.dev` - Development
- `.env.staging` - Staging
- `.env.prod` - Production

## Important Notes

- Main entry point is `lib/main.dart` which runs `SkyAirApp`
- AI chat functionality uses `HyperClovaService` for travel consultation
- The app targets desktop-first design with responsive layouts
- Supports 4 languages: Korean, English, Chinese, Japanese
