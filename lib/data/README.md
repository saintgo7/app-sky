# Data 폴더

외부 데이터 소스와의 통신 및 데이터 처리를 담당하는 폴더입니다.

## 하위 폴더 구조

### api/
- REST API 클라이언트 및 서비스
- Retrofit을 이용한 HTTP 통신
- 예: `travel_api_service.dart`, `auth_api_service.dart`, `booking_api_service.dart`

### models/
- API 응답을 위한 데이터 모델 클래스
- JSON 직렬화/역직렬화 처리
- 예: `destination_model.dart`, `user_model.dart`, `booking_model.dart`

### repositories/
- 데이터 소스들을 추상화하는 Repository 패턴 구현
- 로컬 DB, API, 캐시 등 다양한 데이터 소스 관리
- 예: `travel_repository.dart`, `user_repository.dart`, `booking_repository.dart`

## 역할
- Domain 계층과 외부 데이터 소스 사이의 인터페이스
- 데이터 변환 및 캐싱 로직 처리
- 네트워크 오류 처리 및 재시도 로직