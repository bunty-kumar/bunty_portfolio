import 'package:flutter_test/flutter_test.dart';
import 'package:bunty_portfolio/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const DynamicPortfolioApp());
    expect(find.byType(DynamicPortfolioApp), findsOneWidget);
  });
}
