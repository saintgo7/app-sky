# 🌐 TravelMate 웹서버 설정 가이드

Flutter 웹앱을 다양한 방법으로 배포하고 실행하는 완전한 가이드입니다.

---

## 📋 목차

1. [빠른 시작](#빠른-시작)
2. [개발 환경 설정](#개발-환경-설정)
3. [프로덕션 배포](#프로덕션-배포)
4. [고급 설정](#고급-설정)
5. [문제 해결](#문제-해결)

---

## 🚀 빠른 시작

### 방법 1: Python HTTP 서버 (가장 간단)

```bash
# 1. 빌드 디렉토리로 이동
cd build/web

# 2. 서버 시작 (포트 8080)
python3 -m http.server 8080

# 3. 브라우저에서 열기
# http://localhost:8080
```

**또는 스크립트 사용:**

```bash
# 프로젝트 루트에서
./start_server.sh

# 다른 포트로 실행
./start_server.sh 3000
```

### 방법 2: Flutter 개발 서버

```bash
# Flutter가 설치된 경우
flutter run -d chrome

# 특정 포트 지정
flutter run -d web-server --web-port=8080
```

---

## 🛠️ 개발 환경 설정

### 1. Flutter 웹 빌드

```bash
# 개발용 빌드
flutter build web

# 프로덕션 빌드 (최적화)
flutter build web --release

# 특정 베이스 경로로 빌드
flutter build web --base-href /app/

# 웹 렌더러 선택
flutter build web --web-renderer canvaskit  # 고성능
flutter build web --web-renderer html       # 경량
flutter build web --web-renderer auto       # 자동 선택 (기본)
```

### 2. Python HTTP 서버 (개발용)

**장점:**
- 설치 불필요 (Python 기본 제공)
- 설정 간단
- 개발/테스트에 적합

**단점:**
- 성능 낮음
- 프로덕션 부적합
- HTTPS 미지원

```bash
# 기본 사용
cd build/web
python3 -m http.server 8080

# 특정 IP 바인딩
python3 -m http.server 8080 --bind 0.0.0.0

# 백그라운드 실행
nohup python3 -m http.server 8080 &

# 프로세스 확인
ps aux | grep http.server

# 종료
pkill -f "python3 -m http.server"
```

### 3. Node.js 서버

```bash
# http-server 설치
npm install -g http-server

# 서버 실행
cd build/web
http-server -p 8080

# CORS 활성화
http-server -p 8080 --cors

# 캐시 비활성화 (개발 시)
http-server -p 8080 -c-1
```

### 4. Live Server (VS Code)

```bash
# VS Code Extension 설치
# 1. Extensions에서 "Live Server" 검색
# 2. 설치 후 build/web/index.html 우클릭
# 3. "Open with Live Server" 선택
```

---

## 🏭 프로덕션 배포

### 1. Nginx (권장)

**Nginx 설치:**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx

# macOS
brew install nginx

# 설치 확인
nginx -v
```

**설정 파일 작성:**

`/etc/nginx/sites-available/travelmate` 파일을 생성합니다:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    root /var/www/travelmate/build/web;
    index index.html;

    # Gzip 압축
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript
               application/x-javascript application/xml+rss application/json;

    # SPA 라우팅
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 정적 파일 캐싱
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Flutter 메인 파일은 캐싱 안 함
    location = /main.dart.js {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }

    # 보안 헤더
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
}
```

**Nginx 활성화:**

```bash
# 심볼릭 링크 생성
sudo ln -s /etc/nginx/sites-available/travelmate /etc/nginx/sites-enabled/

# 설정 테스트
sudo nginx -t

# Nginx 재시작
sudo systemctl restart nginx

# 상태 확인
sudo systemctl status nginx
```

**HTTPS 설정 (Let's Encrypt):**

```bash
# Certbot 설치
sudo apt install certbot python3-certbot-nginx

# SSL 인증서 발급
sudo certbot --nginx -d your-domain.com

# 자동 갱신 테스트
sudo certbot renew --dry-run
```

### 2. Apache

**설치:**

```bash
# Ubuntu/Debian
sudo apt install apache2

# 모듈 활성화
sudo a2enmod rewrite
sudo a2enmod headers
```

**설정 파일:**

`/etc/apache2/sites-available/travelmate.conf`:

```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/travelmate/build/web

    <Directory /var/www/travelmate/build/web>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        # SPA 라우팅
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    # Gzip 압축
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
    </IfModule>

    # 캐싱
    <FilesMatch "\.(js|css|png|jpg|jpeg|gif|ico|svg)$">
        Header set Cache-Control "max-age=31536000, public"
    </FilesMatch>
</VirtualHost>
```

**활성화:**

```bash
sudo a2ensite travelmate
sudo systemctl restart apache2
```

### 3. Docker (컨테이너 배포)

**Dockerfile 작성:**

```dockerfile
# Multi-stage build
FROM debian:latest AS build-env

# Flutter SDK 설치
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN flutter channel stable
RUN flutter upgrade

# 앱 복사 및 빌드
COPY . /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web --release

# Nginx stage
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**빌드 및 실행:**

```bash
# Docker 이미지 빌드
docker build -t travelmate-web -f Dockerfile.web .

# 컨테이너 실행
docker run -d -p 8080:80 --name travelmate travelmate-web

# 로그 확인
docker logs travelmate

# 중지
docker stop travelmate

# 삭제
docker rm travelmate
```

**Docker Compose:**

`docker-compose.yml`:

```yaml
version: '3.8'

services:
  travelmate:
    build:
      context: .
      dockerfile: Dockerfile.web
    ports:
      - "8080:80"
    restart: unless-stopped
    environment:
      - NODE_ENV=production
```

실행:

```bash
docker-compose up -d
docker-compose logs -f
docker-compose down
```

---

## ☁️ 클라우드 배포

### 1. Firebase Hosting (권장 - 무료)

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# 로그인
firebase login

# 프로젝트 초기화
firebase init hosting

# 빌드
flutter build web

# 배포
firebase deploy --only hosting

# 특정 프로젝트에 배포
firebase use your-project-id
firebase deploy
```

`firebase.json`:

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### 2. Vercel

```bash
# Vercel CLI 설치
npm install -g vercel

# 로그인
vercel login

# 배포
vercel --prod
```

`vercel.json`:

```json
{
  "buildCommand": "flutter build web",
  "outputDirectory": "build/web",
  "framework": null,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### 3. Netlify

```bash
# Netlify CLI 설치
npm install -g netlify-cli

# 로그인
netlify login

# 배포
netlify deploy --prod --dir=build/web
```

`netlify.toml`:

```toml
[build]
  command = "flutter build web"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### 4. GitHub Pages

```bash
# 1. Flutter 웹 빌드
flutter build web --base-href "/repository-name/"

# 2. gh-pages 브랜치 생성
git checkout -b gh-pages
git add build/web -f
git commit -m "Deploy to GitHub Pages"
git subtree push --prefix build/web origin gh-pages

# 또는 자동화
```

`.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.x'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Build web
      run: flutter build web --release --base-href "/repository-name/"

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

---

## ⚙️ 고급 설정

### 1. 환경 변수 설정

`.env.production`:

```bash
API_URL=https://api.production.com
FIREBASE_API_KEY=your-api-key
GOOGLE_ANALYTICS_ID=UA-XXXXX-X
```

빌드 시:

```bash
flutter build web --dart-define=API_URL=https://api.production.com
```

### 2. 서비스 워커 설정

`flutter_service_worker.js` 커스터마이징:

```javascript
// 캐시 버전
const CACHE_NAME = 'travelmate-v1';

// 캐시할 리소스
const urlsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/assets/fonts/',
  '/assets/images/',
];

// 설치 이벤트
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});
```

### 3. 로드 밸런싱 (Nginx)

```nginx
upstream travelmate_backend {
    least_conn;
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}

server {
    listen 80;

    location / {
        proxy_pass http://travelmate_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. CDN 설정

**CloudFlare:**

1. CloudFlare 계정 생성
2. 도메인 추가
3. DNS 레코드 설정
4. SSL/TLS 설정 (Full)
5. 캐싱 규칙 설정

**AWS CloudFront:**

```bash
aws cloudfront create-distribution \
  --origin-domain-name your-bucket.s3.amazonaws.com \
  --default-root-object index.html
```

---

## 🔧 문제 해결

### 1. 포트가 이미 사용 중

```bash
# 포트 사용 프로세스 찾기
lsof -ti:8080

# 프로세스 종료
kill -9 $(lsof -ti:8080)

# 또는 다른 포트 사용
python3 -m http.server 3000
```

### 2. 라우팅이 작동하지 않음

**Python HTTP 서버의 경우:**
- SPA 라우팅 미지원
- Nginx 또는 Firebase Hosting 사용 권장

**Nginx 설정 추가:**
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

### 3. CORS 에러

**개발 서버에서:**

```bash
# http-server 사용
http-server -p 8080 --cors

# 또는 Chrome CORS 비활성화 (개발 전용)
google-chrome --disable-web-security --user-data-dir=/tmp/chrome
```

**Nginx 설정:**

```nginx
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
add_header Access-Control-Allow-Headers "Origin, Content-Type, Accept";
```

### 4. 캐싱 문제

```bash
# 브라우저 캐시 강제 새로고침
Ctrl + Shift + R (Windows/Linux)
Cmd + Shift + R (Mac)

# 서버 측 캐시 비활성화 (Nginx)
add_header Cache-Control "no-cache, no-store, must-revalidate";
```

### 5. 파일 권한 문제

```bash
# 빌드 디렉토리 권한 설정
chmod -R 755 build/web

# 소유자 변경 (Nginx)
sudo chown -R www-data:www-data /var/www/travelmate
```

---

## 📊 성능 최적화

### 1. 빌드 최적화

```bash
# Tree shaking (불필요한 코드 제거)
flutter build web --tree-shake-icons

# 난독화
flutter build web --obfuscate --split-debug-info=debug-info/

# 웹 렌더러 최적화
flutter build web --web-renderer canvaskit --release
```

### 2. 압축 설정

**Nginx Gzip:**

```nginx
gzip on;
gzip_vary on;
gzip_comp_level 6;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
```

**Brotli 압축 (더 효율적):**

```nginx
brotli on;
brotli_comp_level 6;
brotli_types text/plain text/css application/json application/javascript text/xml application/xml;
```

### 3. 이미지 최적화

```bash
# WebP 변환
for img in assets/images/*.png; do
  cwebp -q 80 "$img" -o "${img%.png}.webp"
done

# SVG 최적화
npm install -g svgo
svgo -f assets/icons/
```

---

## 📈 모니터링

### 1. 액세스 로그 (Nginx)

```nginx
access_log /var/log/nginx/travelmate_access.log;
error_log /var/log/nginx/travelmate_error.log;
```

로그 확인:

```bash
tail -f /var/log/nginx/travelmate_access.log
```

### 2. Google Analytics

`web/index.html`에 추가:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

---

## 🎯 권장 사항

### 개발 환경:
1. **Flutter 개발 서버** (`flutter run -d chrome`) - 핫 리로드
2. **Python HTTP 서버** - 빠른 테스트

### 스테이징:
1. **Docker + Nginx** - 프로덕션과 동일 환경
2. **Vercel/Netlify** - 빠른 배포

### 프로덕션:
1. **Firebase Hosting** - 무료, CDN, SSL 자동
2. **Nginx + Docker** - 자체 서버
3. **CloudFlare + S3** - 대규모 트래픽

---

## 📝 체크리스트

배포 전 확인사항:

- [ ] `flutter build web --release` 실행
- [ ] 환경 변수 설정 확인
- [ ] API 엔드포인트 프로덕션 URL로 변경
- [ ] HTTPS 설정 완료
- [ ] 캐싱 정책 설정
- [ ] 압축 활성화 (Gzip/Brotli)
- [ ] 보안 헤더 설정
- [ ] 모니터링 설정
- [ ] 백업 계획 수립
- [ ] 롤백 계획 준비

---

**작성일:** 2025-11-14
**버전:** 1.0.0
**앱:** TravelMate Flutter Web
