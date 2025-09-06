# 스카이 항공 서버 실행 가이드

## 빠른 시작

### 1. 서버 시작
```bash
cd /home/ubuntu/sky-air
python3 -m http.server 8000
```

### 2. 애플리케이션 접속
브라우저에서 다음 중 하나로 접속:
- **메인 접속**: http://localhost:8000/
- **직접 접속**: http://localhost:8000/final_app.html

## 백그라운드 실행

### 서버를 백그라운드에서 실행하기
```bash
nohup python3 -m http.server 8000 > server.log 2>&1 &
```

### 실행 중인 서버 확인
```bash
ps aux | grep "python3 -m http.server"
```

### 서버 중지
```bash
pkill -f "python3 -m http.server 8000"
```

## 애플리케이션 기능

### ✅ 구현된 기능들
- **스카이 항공 브랜딩**: Trip.com 스타일의 모던한 디자인
- **HyperCLOVA X SEED AI 통합**: 네이버 AI 모델 기반 여행 추천
- **인터랙티브 검색**: 항공권, 호텔, 패키지 탭 전환
- **반응형 디자인**: 데스크톱 및 모바일 최적화
- **AI 여행 플래너**: 맞춤형 추천 및 실시간 상담

### 🎯 주요 인터랙션
1. **검색 탭**: 항공권/호텔/패키지 간 전환
2. **검색 기능**: 여행지 검색 (데모용 알림)
3. **AI 플래너**: HyperCLOVA X SEED 기능 소개

## 파일 구조
```
/home/ubuntu/sky-air/
├── index.html           # 자동 리다이렉트 페이지
├── final_app.html       # 메인 애플리케이션
├── server.log          # 서버 로그
└── SERVER_INSTRUCTIONS.md  # 이 문서
```

## 문제 해결

### 포트가 이미 사용 중인 경우
```bash
# 다른 포트 사용
python3 -m http.server 8080
```

### 접속이 안 되는 경우
1. 서버가 실행 중인지 확인: `ps aux | grep python3`
2. 포트 확인: `netstat -tulpn | grep 8000`
3. 방화벽 설정 확인

## 개발자 노트
- 이 HTML 버전은 Flutter 웹 표시 문제에 대한 안정적인 대안입니다
- 모든 핵심 기능이 순수 HTML/CSS/JavaScript로 구현되었습니다
- 프로덕션 환경에서는 더 강력한 웹 서버 (nginx, Apache) 사용을 권장합니다