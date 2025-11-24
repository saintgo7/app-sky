# TravelMate 🌍

Flutter로 개발된 AI 기반 여행사 플랫폼입니다. 포괄적인 예약 시스템과 개인화된 여행 추천 서비스를 제공합니다.

## 주요 기능

- 🤖 AI 기반 여행 상담 및 추천
- ✈️ 항공편, 호텔, 액티비티 통합 예약
- 💳 다양한 결제 수단 지원 (아임포트, 부트페이)
- 🌐 다국어 지원 (한국어, 영어, 중국어, 일본어)
- 📱 실시간 알림 및 채팅
- 📊 개인화된 여행 분석

## 프로젝트 구조

```
lib/
├── core/              # 앱 핵심 기능 (상수, 테마, 유틸리티)
├── data/              # 데이터 계층 (API, 모델, 리포지토리)
├── domain/            # 비즈니스 로직 (엔티티, 유즈케이스)
├── presentation/      # UI 계층 (화면, 위젯, 상태관리)
└── services/          # 외부 서비스 (AI, 알림, 결제)
```

## 기술 스택

### 상태 관리
- Provider 6.1.2
- Riverpod 2.5.1

### 네트워킹
- Dio 5.4.2
- Retrofit 4.1.0

### Firebase
- Firebase Auth
- Firebase Messaging
- Google Sign In

### 결제
- 아임포트 (iamport_flutter)
- 부트페이 (bootpay)

### AI/ML
- Flutter Dialogflow
- Google ML Kit

### UI/UX
- Flutter ScreenUtil
- Cached Network Image
- Lottie Animations

## 환경 설정

프로젝트는 다음 세 가지 환경을 지원합니다:

- **개발환경**: `.env.dev`
- **스테이징**: `.env.staging`
- **프로덕션**: `.env.prod`

### 환경 변수 설정

프로젝트 루트에 `.env` 파일을 생성하고 다음 변수를 설정하세요:

```env
# API Configuration
API_BASE_URL=https://api.travelmate.com/v1
API_KEY=your_api_key_here

# Authentication
AUTH_BASE_URL=https://auth.travelmate.com

# External Services - Maps
NAVER_MAP_CLIENT_ID=your_naver_client_id
NAVER_MAP_CLIENT_SECRET=your_naver_client_secret
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Payment - Iamport
IAMPORT_CODE=imp12345678
IAMPORT_API_KEY=your_iamport_api_key
IAMPORT_API_SECRET=your_iamport_api_secret

# Firebase
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id

# AI Service
AI_SERVICE_URL=https://ai.travelmate.com
AI_API_KEY=your_ai_api_key

# Environment
ENVIRONMENT=development

# Database
DATABASE_NAME=travelmate.db

# Cache Duration (hours)
CACHE_DURATION_HOURS=24

# API Timeout (seconds)
API_TIMEOUT_SECONDS=30
```

## 시작하기

1. 의존성 설치
```bash
flutter pub get
```

2. 환경 파일 설정
```bash
# .env, .env.dev, .env.staging, .env.prod 파일에 실제 값 입력
```

3. 코드 생성
```bash
flutter packages pub run build_runner build
```

4. 앱 실행
```bash
flutter run
```

## 다국어 지원

이 앱은 4개 언어를 지원합니다:
- 🇰🇷 한국어 (ko)
- 🇺🇸 영어 (en)  
- 🇨🇳 중국어 (zh)
- 🇯🇵 일본어 (ja)

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.