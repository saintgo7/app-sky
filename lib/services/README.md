# Services 폴더

외부 서비스 및 플랫폼별 기능을 통합하는 폴더입니다.

## 하위 폴더 구조

### ai/
- AI 관련 서비스 통합
- Dialogflow를 통한 챗봇 기능
- Google ML Kit을 이용한 이미지/텍스트 인식
- 예: `chatbot_service.dart`, `ml_service.dart`, `recommendation_service.dart`

### notifications/
- 푸시 알림 및 로컬 알림 관리
- Firebase Messaging 통합
- 알림 스케줄링 및 관리
- 예: `push_notification_service.dart`, `local_notification_service.dart`

### payments/
- 결제 시스템 통합
- 아임포트(iamport)와 부트페이(bootpay) 연동
- 결제 처리 및 검증
- 예: `iamport_service.dart`, `bootpay_service.dart`, `payment_manager.dart`

## 주요 기능

### AI 서비스
- 자연어 처리를 통한 여행 상담
- 이미지 인식을 통한 관광지 정보 제공
- 개인화된 여행 추천

### 알림 서비스
- 예약 확인 알림
- 여행 일정 리마인더
- 프로모션 및 할인 정보

### 결제 서비스
- 다양한 결제 수단 지원
- 안전한 결제 처리
- 결제 내역 관리

모든 서비스는 의존성 주입을 통해 테스트 가능하도록 설계되어야 합니다.