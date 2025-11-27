// 스카이 항공 기본 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skyair/main.dart';

void main() {
  testWidgets('SkyAir app smoke test', (WidgetTester tester) async {
    // 앱 빌드
    await tester.pumpWidget(const SkyAirApp());

    // 스카이 항공 타이틀 확인
    expect(find.text('스카이 항공'), findsWidgets);

    // 메인 슬로건 확인
    expect(find.text('어디로 떠나시나요?'), findsOneWidget);
  });
}
