import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleaner/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FinalCleanerApp());
    expect(find.text('Final Cleaner'), findsOneWidget);
  });
}
