import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fin_monitor/main.dart';

void main() {
  testWidgets('Показує заголовок дашборду', (tester) async {
    await tester.pumpWidget(const FinanceMonitorApp());

    expect(find.text('Фінансовий моніторинг'), findsOneWidget);
    expect(find.text('Останні операції'), findsOneWidget);
  });
}
