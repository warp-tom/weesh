import 'package:flutter_test/flutter_test.dart';
import 'package:weesh_driver/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: WeeshDriverApp(),
      ),
    );

    // Verify that the app builds and renders something.
    // The splash screen or login screen should be present.
    expect(find.byType(WeeshDriverApp), findsOneWidget);
  });
}
