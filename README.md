# 스카이 항공

Flutter로 개발된 AI 기반 항공권 예약 및 여행 서비스 플랫폼입니다.

## 주요 기능

- 항공권/호텔/렌터카/패키지 검색 및 예약
- HyperCLOVA X SEED 기반 AI 여행 상담
- 다국어 지원 (한국어, 영어, 중국어, 일본어)
- 스카이 마일리지 적립

## 프로젝트 구조

```
lib/
├── core/              # 앱 핵심 기능 (상수, 테마, 유틸리티)
├── services/          # AI 서비스
├── presentation/      # UI 계층 (화면)
└── main.dart          # 앱 진입점
```

## 기술 스택

- **프레임워크**: Flutter 3.8+
- **AI**: HyperCLOVA X SEED (네이버 AI)
- **상태관리**: Provider

## 시작하기

1. 의존성 설치
```bash
flutter pub get
```

2. 앱 실행
```bash
flutter run
```

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
