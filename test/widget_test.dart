import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maize_doctor/main.dart';
import 'package:maize_doctor/providers/history_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Maize Doctor app builds', (WidgetTester tester) async {
    final historyProvider = HistoryProvider();
    await historyProvider.init();

    await tester.pumpWidget(
      MaizeDoctorApp(historyProvider: historyProvider),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaizeDoctorApp), findsOneWidget);
  });
}