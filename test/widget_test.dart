import 'package:flutter_test/flutter_test.dart';
import 'package:dishdash/main.dart';

void main() {
  testWidgets('DishDash smoke test', (WidgetTester tester) async {
    // Tətbiqi işə salır
    await tester.pumpWidget(const DishDashApp());
  });
}