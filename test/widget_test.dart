import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleanner/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FinalCleannerApp());
    expect(find.text('Final Cleanner'), findsOneWidget);
  });
}
