import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/app.dart';

void main() {
  testWidgets('Nexora login screen appears',
          (WidgetTester tester) async {
        await tester.pumpWidget(const Nexora());

        expect(find.text('Nexora'), findsOneWidget);
        expect(find.text('Welcome Back!'), findsOneWidget);
      });
}