// Basic Flutter widget test for Blank Canvas app

import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile/app.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BlankCanvasApp());

    // Verify app builds successfully - splash screen should show app name
    expect(find.text('BLANK CANVAS'), findsOneWidget);
  });
}
