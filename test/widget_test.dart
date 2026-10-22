import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_chain/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HabitChain App loads and renders successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const HabitChainApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(HabitChainApp), findsOneWidget);
  });
}
