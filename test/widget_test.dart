import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookia/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test: loads SplashView and renders Logo text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our SplashView displays the welcome/order text.
    expect(find.text('Order Your Book Now!'), findsOneWidget);

    // Pump the timer duration to allow SplashView timer to complete and avoid pending timer error.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });
}
