# 🚀 빠른 웹서버 실행 가이드

## 1️⃣ Python 서버 (가장 간단)

```bash
cd /home/user/app-sky
./start_server.sh
```

또는:

```bash
cd /home/user/app-sky/build/web
python3 -m http.server 8080
```

브라우저에서 열기: **http://localhost:8080**

---

## 2️⃣ 다른 포트로 실행

```bash
# 포트 3000으로 실행
./start_server.sh 3000

# 또는
cd build/web
python3 -m http.server 3000
```

---

## 3️⃣ 외부 접속 허용

```bash
cd build/web
python3 -m http.server 8080 --bind 0.0.0.0
```

이제 다른 컴퓨터에서도 접속 가능:
- **http://your-ip-address:8080**

---

## 4️⃣ 백그라운드 실행

```bash
# 백그라운드로 실행
cd build/web
nohup python3 -m http.server 8080 > server.log 2>&1 &

# 프로세스 ID 확인
echo $!

# 나중에 종료
kill -9 $(lsof -ti:8080)
```

---

## 5️⃣ 현재 실행 중인 서버 확인

```bash
# 포트 확인
lsof -ti:8080

# 프로세스 확인
ps aux | grep http.server
```

---

## 6️⃣ 서버 중지

```bash
# 방법 1: Ctrl+C (포그라운드 실행 시)

# 방법 2: 프로세스 종료
pkill -f "python3 -m http.server"

# 방법 3: 특정 포트 종료
kill -9 $(lsof -ti:8080)
```

---

## 🔥 새 코드로 다시 빌드하기

현재 build/web은 이전 코드입니다.
새로 수정한 코드를 보려면:

```bash
# Flutter가 설치된 환경에서
flutter pub get
flutter build web --release

# 그리고 서버 재시작
./start_server.sh
```

---

## 💡 팁

**포트가 이미 사용 중일 때:**
```bash
# 다른 포트 사용
python3 -m http.server 3000
python3 -m http.server 4000
python3 -m http.server 5000
```

**자동으로 브라우저 열기:**
```bash
# macOS
python3 -m http.server 8080 & sleep 2 && open http://localhost:8080

# Linux
python3 -m http.server 8080 & sleep 2 && xdg-open http://localhost:8080

# Windows
python -m http.server 8080 & timeout 2 & start http://localhost:8080
```

---

## 📱 모바일에서 접속

1. 컴퓨터와 모바일이 같은 Wi-Fi에 연결
2. 컴퓨터 IP 주소 확인:
   ```bash
   # Linux/Mac
   ifconfig | grep "inet "
   
   # 또는
   ip addr show
   ```
3. 서버를 0.0.0.0으로 바인딩:
   ```bash
   python3 -m http.server 8080 --bind 0.0.0.0
   ```
4. 모바일에서 접속:
   ```
   http://192.168.x.x:8080
   ```

---

**현재 위치:** /home/user/app-sky  
**빌드 디렉토리:** /home/user/app-sky/build/web  
**메인 파일 크기:** 2.2MB
