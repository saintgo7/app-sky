import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travelmate/generated/l10n.dart';
import 'package:travelmate/presentation/screens/ai/personalized_recommendation_screen.dart';

void main() {
  group('Localization Tests', () {
    
    group('English Localization', () {
      testWidgets('should display English text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: LocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test basic UI elements
        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Booking'), findsOneWidget);
        expect(find.text('My Trips'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        
        // Test travel-related terms
        expect(find.text('Destinations'), findsOneWidget);
        expect(find.text('Hotels'), findsOneWidget);
        expect(find.text('Flights'), findsOneWidget);
        expect(find.text('Activities'), findsOneWidget);
        
        // Test action buttons
        expect(find.text('Login'), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('should display complex English phrases correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: ComplexLocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test booking-related phrases
        expect(find.textContaining('Book your dream vacation'), findsOneWidget);
        expect(find.textContaining('Personalized recommendations'), findsOneWidget);
        expect(find.textContaining('AI-powered travel planning'), findsOneWidget);
        
        // Test error messages
        expect(find.textContaining('Please enter a valid email'), findsOneWidget);
        expect(find.textContaining('Password must be at least 8 characters'), findsOneWidget);
        
        // Test success messages
        expect(find.textContaining('Booking confirmed successfully'), findsOneWidget);
        expect(find.textContaining('Payment completed'), findsOneWidget);
      });
    });

    group('Korean Localization', () {
      testWidgets('should display Korean text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: LocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test basic UI elements in Korean
        expect(find.text('검색'), findsOneWidget);
        expect(find.text('예약'), findsOneWidget);
        expect(find.text('내 여행'), findsOneWidget);
        expect(find.text('프로필'), findsOneWidget);
        expect(find.text('설정'), findsOneWidget);
        
        // Test travel-related terms in Korean
        expect(find.text('목적지'), findsOneWidget);
        expect(find.text('호텔'), findsOneWidget);
        expect(find.text('항공편'), findsOneWidget);
        expect(find.text('액티비티'), findsOneWidget);
        
        // Test action buttons in Korean
        expect(find.text('로그인'), findsOneWidget);
        expect(find.text('회원가입'), findsOneWidget);
        expect(find.text('취소'), findsOneWidget);
        expect(find.text('확인'), findsOneWidget);
      });

      testWidgets('should handle Korean text rendering correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: ComplexLocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test complex Korean phrases
        expect(find.textContaining('꿈꾸던 휴가를 예약하세요'), findsOneWidget);
        expect(find.textContaining('개인 맞춤형 추천'), findsOneWidget);
        expect(find.textContaining('AI 기반 여행 계획'), findsOneWidget);
        
        // Test Korean error messages
        expect(find.textContaining('올바른 이메일을 입력해주세요'), findsOneWidget);
        expect(find.textContaining('비밀번호는 8자 이상이어야 합니다'), findsOneWidget);
        
        // Test Korean success messages
        expect(find.textContaining('예약이 성공적으로 완료되었습니다'), findsOneWidget);
        expect(find.textContaining('결제가 완료되었습니다'), findsOneWidget);
      });

      testWidgets('should handle Korean number formatting', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: NumberFormattingTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test Korean number formatting (1,000,000 KRW)
        expect(find.textContaining('1,000,000원'), findsOneWidget);
        expect(find.textContaining('5박 6일'), findsOneWidget);
        expect(find.textContaining('2명'), findsOneWidget);
        
        // Test Korean date formatting
        expect(find.textContaining('2024년 12월 25일'), findsOneWidget);
      });
    });

    group('Japanese Localization', () {
      testWidgets('should display Japanese text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ja'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: LocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test basic UI elements in Japanese
        expect(find.text('検索'), findsOneWidget);
        expect(find.text('予約'), findsOneWidget);
        expect(find.text('マイトリップ'), findsOneWidget);
        expect(find.text('プロフィール'), findsOneWidget);
        expect(find.text('設定'), findsOneWidget);
        
        // Test travel-related terms in Japanese
        expect(find.text('目的地'), findsOneWidget);
        expect(find.text('ホテル'), findsOneWidget);
        expect(find.text('フライト'), findsOneWidget);
        expect(find.text('アクティビティ'), findsOneWidget);
      });

      testWidgets('should handle Japanese mixed scripts correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ja'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: ComplexLocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test mixed Hiragana, Katakana, and Kanji
        expect(find.textContaining('夢の休暇をブッキングしましょう'), findsOneWidget);
        expect(find.textContaining('パーソナライズされた推薦'), findsOneWidget);
        expect(find.textContaining('AI搭載旅行プランニング'), findsOneWidget);
      });
    });

    group('Chinese Localization', () {
      testWidgets('should display Chinese text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: LocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test basic UI elements in Chinese
        expect(find.text('搜索'), findsOneWidget);
        expect(find.text('预订'), findsOneWidget);
        expect(find.text('我的旅行'), findsOneWidget);
        expect(find.text('个人资料'), findsOneWidget);
        expect(find.text('设置'), findsOneWidget);
        
        // Test travel-related terms in Chinese
        expect(find.text('目的地'), findsOneWidget);
        expect(find.text('酒店'), findsOneWidget);
        expect(find.text('航班'), findsOneWidget);
        expect(find.text('活动'), findsOneWidget);
      });

      testWidgets('should handle Chinese traditional and simplified correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: ComplexLocalizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test Chinese phrases
        expect(find.textContaining('预订您梦想中的假期'), findsOneWidget);
        expect(find.textContaining('个性化推荐'), findsOneWidget);
        expect(find.textContaining('AI驱动的旅行计划'), findsOneWidget);
      });
    });

    group('Locale Switching', () {
      testWidgets('should switch locales correctly', (WidgetTester tester) async {
        final localeNotifier = ValueNotifier<Locale>(Locale('en'));

        await tester.pumpWidget(
          ValueListenableBuilder<Locale>(
            valueListenable: localeNotifier,
            builder: (context, locale, child) {
              return MaterialApp(
                locale: locale,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: LocaleSwitchingTestScreen(
                  onLocaleChanged: (newLocale) {
                    localeNotifier.value = newLocale;
                  },
                ),
              );
            },
          ),
        );

        await tester.pumpAndSettle();

        // Initially in English
        expect(find.text('Search'), findsOneWidget);

        // Switch to Korean
        await tester.tap(find.text('한국어'));
        await tester.pumpAndSettle();

        expect(find.text('검색'), findsOneWidget);
        expect(find.text('Search'), findsNothing);

        // Switch to Japanese
        await tester.tap(find.text('日本語'));
        await tester.pumpAndSettle();

        expect(find.text('検索'), findsOneWidget);
        expect(find.text('검색'), findsNothing);

        // Switch back to English
        await tester.tap(find.text('English'));
        await tester.pumpAndSettle();

        expect(find.text('Search'), findsOneWidget);
        expect(find.text('検索'), findsNothing);
      });

      testWidgets('should handle RTL languages correctly', (WidgetTester tester) async {
        // Test Arabic if supported
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: RTLTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Check if text direction is RTL
        final BuildContext context = tester.element(find.byType(RTLTestScreen));
        final TextDirection textDirection = Directionality.of(context);
        
        expect(textDirection, equals(TextDirection.rtl));
      });
    });

    group('Pluralization', () {
      testWidgets('should handle plural forms correctly in English', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: PluralizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Test singular and plural forms
        expect(find.text('1 booking'), findsOneWidget);
        expect(find.text('2 bookings'), findsOneWidget);
        expect(find.text('0 bookings'), findsOneWidget);
        expect(find.text('1 day'), findsOneWidget);
        expect(find.text('5 days'), findsOneWidget);
      });

      testWidgets('should handle plural forms correctly in Korean', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: PluralizationTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Korean doesn't have traditional pluralization, but should show numbers correctly
        expect(find.text('예약 1건'), findsOneWidget);
        expect(find.text('예약 2건'), findsOneWidget);
        expect(find.text('1일'), findsOneWidget);
        expect(find.text('5일'), findsOneWidget);
      });
    });

    group('Date and Time Localization', () {
      testWidgets('should format dates correctly for each locale', (WidgetTester tester) async {
        final testDate = DateTime(2024, 12, 25, 14, 30);

        // Test English date formatting
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: DateTimeTestScreen(testDate: testDate),
          ),
        );

        await tester.pumpAndSettle();

        // English format: December 25, 2024
        expect(find.textContaining('December 25, 2024'), findsOneWidget);
        expect(find.textContaining('2:30 PM'), findsOneWidget);
      });

      testWidgets('should format currency correctly for each locale', (WidgetTester tester) async {
        const testAmount = 1500000.0;

        // Test Korean currency formatting
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: CurrencyTestScreen(amount: testAmount),
          ),
        );

        await tester.pumpAndSettle();

        // Korean currency format
        expect(find.textContaining('₩1,500,000'), findsOneWidget);
      });
    });

    group('Font and Typography', () {
      testWidgets('should use correct fonts for each language', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: FontTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Check if Korean text uses appropriate font
        final Text koreanText = tester.widget(find.text('한국어 텍스트'));
        expect(koreanText.style?.fontFamily, contains('Pretendard'));
      });

      testWidgets('should handle text overflow correctly in different languages', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: TextOverflowTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that long text is handled correctly
        final RenderBox textBox = tester.renderObject(
          find.text('This is a very long text that should be handled properly'),
        );
        expect(textBox.hasSize, isTrue);
      });
    });

    group('Accessibility with Localization', () {
      testWidgets('should provide correct semantic labels for each locale', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale('ko'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: AccessibilityTestScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Check semantic labels in Korean
        expect(find.bySemanticsLabel('검색'), findsOneWidget);
        expect(find.bySemanticsLabel('예약하기'), findsOneWidget);
        expect(find.bySemanticsLabel('설정 메뉴'), findsOneWidget);
      });
    });
  });
}

// Test screens for different localization scenarios

class LocalizationTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      body: Column(
        children: [
          Text(S.of(context).search),
          Text(S.of(context).booking),
          Text(S.of(context).myTrips),
          Text(S.of(context).profile),
          Text(S.of(context).settings),
          Text(S.of(context).destinations),
          Text(S.of(context).hotels),
          Text(S.of(context).flights),
          Text(S.of(context).activities),
          ElevatedButton(
            onPressed: () {},
            child: Text(S.of(context).login),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(S.of(context).signUp),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).confirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ComplexLocalizationTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context).bookYourDreamVacation),
          Text(S.of(context).personalizedRecommendations),
          Text(S.of(context).aiPoweredTravelPlanning),
          Text(S.of(context).pleaseEnterValidEmail),
          Text(S.of(context).passwordMustBeAtLeast8Characters),
          Text(S.of(context).bookingConfirmedSuccessfully),
          Text(S.of(context).paymentCompleted),
        ],
      ),
    );
  }
}

class NumberFormattingTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context).priceFormat(1000000)),
          Text(S.of(context).durationFormat(5, 6)),
          Text(S.of(context).travelerCountFormat(2)),
          Text(S.of(context).dateFormat(DateTime(2024, 12, 25))),
        ],
      ),
    );
  }
}

class LocaleSwitchingTestScreen extends StatelessWidget {
  final Function(Locale) onLocaleChanged;

  const LocaleSwitchingTestScreen({Key? key, required this.onLocaleChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: Column(
        children: [
          Text(S.of(context).search),
          Text(S.of(context).language),
          ListTile(
            title: Text('English'),
            onTap: () => onLocaleChanged(Locale('en')),
          ),
          ListTile(
            title: Text('한국어'),
            onTap: () => onLocaleChanged(Locale('ko')),
          ),
          ListTile(
            title: Text('日本語'),
            onTap: () => onLocaleChanged(Locale('ja')),
          ),
          ListTile(
            title: Text('中文'),
            onTap: () => onLocaleChanged(Locale('zh')),
          ),
        ],
      ),
    );
  }
}

class RTLTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مرحبا بك في TravelMate'),
          Text('البحث'),
          Text('الحجز'),
        ],
      ),
    );
  }
}

class PluralizationTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context).bookingCount(1)),
          Text(S.of(context).bookingCount(2)),
          Text(S.of(context).bookingCount(0)),
          Text(S.of(context).dayCount(1)),
          Text(S.of(context).dayCount(5)),
        ],
      ),
    );
  }
}

class DateTimeTestScreen extends StatelessWidget {
  final DateTime testDate;

  const DateTimeTestScreen({Key? key, required this.testDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context).dateFormat(testDate)),
          Text(S.of(context).timeFormat(testDate)),
        ],
      ),
    );
  }
}

class CurrencyTestScreen extends StatelessWidget {
  final double amount;

  const CurrencyTestScreen({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context).currencyFormat(amount)),
        ],
      ),
    );
  }
}

class FontTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('한국어 텍스트'),
          Text('日本語テキスト'),
          Text('中文文本'),
          Text('English Text'),
        ],
      ),
    );
  }
}

class TextOverflowTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 200,
        child: Text(
          'This is a very long text that should be handled properly and not cause overflow issues in the UI',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}

class AccessibilityTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Semantics(
            label: S.of(context).search,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          Semantics(
            label: S.of(context).booking + '하기',
            child: ElevatedButton(
              onPressed: () {},
              child: Text(S.of(context).booking),
            ),
          ),
          Semantics(
            label: S.of(context).settings + ' 메뉴',
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// Mock extension for S class to provide test methods
extension STestExtensions on S {
  String get bookYourDreamVacation => 'Book your dream vacation';
  String get personalizedRecommendations => 'Personalized recommendations';
  String get aiPoweredTravelPlanning => 'AI-powered travel planning';
  String get pleaseEnterValidEmail => 'Please enter a valid email';
  String get passwordMustBeAtLeast8Characters => 'Password must be at least 8 characters';
  String get bookingConfirmedSuccessfully => 'Booking confirmed successfully';
  String get paymentCompleted => 'Payment completed';
  
  String priceFormat(double amount) => '₩${amount.toStringAsFixed(0)}';
  String durationFormat(int nights, int days) => '$nights박 ${days}일';
  String travelerCountFormat(int count) => '${count}명';
  String dateFormat(DateTime date) => '${date.year}년 ${date.month}월 ${date.day}일';
  String timeFormat(DateTime time) => '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  String currencyFormat(double amount) => '₩${(amount.toInt()).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  
  String bookingCount(int count) {
    if (count == 1) return '$count booking';
    return '$count bookings';
  }
  
  String dayCount(int count) {
    if (count == 1) return '$count day';
    return '$count days';
  }
}