# Core 폴더

애플리케이션의 핵심 기능과 공통 요소들을 관리하는 폴더입니다.

## 하위 폴더 구조

### constants/
- 앱 전반에서 사용되는 상수값들
- API 엔드포인트, 색상 코드, 문자열 상수 등
- 예: `app_constants.dart`, `api_constants.dart`, `color_constants.dart`

### themes/
- 앱의 UI 테마 및 스타일 정의
- 라이트/다크 테마, 커스텀 테마 설정
- 예: `app_theme.dart`, `light_theme.dart`, `dark_theme.dart`

### utils/
- 공통 유틸리티 함수들
- 날짜 포맷팅, 문자열 처리, 검증 로직 등
- 예: `date_utils.dart`, `validator.dart`, `string_utils.dart`

### environment/
- 환경 설정 관리
- 개발/스테이징/프로덕션 환경별 설정
- 예: `app_environment.dart`

이 폴더의 모든 코드는 도메인 로직과 독립적이며, 앱 전체에서 재사용 가능해야 합니다.