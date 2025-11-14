#!/bin/bash
# TravelMate 웹서버 시작 스크립트

PORT=${1:-8080}
BUILD_DIR="build/web"

echo "======================================"
echo "TravelMate 웹서버 시작"
echo "======================================"
echo ""
echo "📂 빌드 디렉토리: $BUILD_DIR"
echo "🌐 포트: $PORT"
echo "🔗 URL: http://localhost:$PORT"
echo ""
echo "서버를 중지하려면 Ctrl+C를 누르세요"
echo "======================================"
echo ""

cd "$BUILD_DIR" && python3 -m http.server "$PORT"
