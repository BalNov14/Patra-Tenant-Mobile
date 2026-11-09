import 'package:flutter_test/flutter_test.dart';

import 'package:easy_parkir_mobile/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Easy Parkir'), findsOneWidget);
    expect(find.text('Smart Parking System'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
