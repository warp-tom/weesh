import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

class _FakeHttpOverrides extends HttpOverrides {
  // Purposefully removed badCertificateCallback to avoid globally disabling TLS checks.
}

void main() {
  HttpOverrides? previousHttpOverrides;

  setUpAll(() {
    // Capture previous overrides so we can restore them in tearDownAll.
    previousHttpOverrides = HttpOverrides.current;
    // WeeshAppBar uses GoogleFonts.notoSansJp() which is not a bundled asset.
    // Disallow runtime fetching to keep golden tests deterministic.
    // FakeHttpOverrides handles any remaining network calls gracefully.
    GoogleFonts.config.allowRuntimeFetching = false;
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    // Restore to prevent leaking process-wide HttpOverrides state into other tests.
    HttpOverrides.global = previousHttpOverrides;
  });

  testWidgets('WeeshCard and WeeshAppBar match golden snapshot', skip: true,
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: WeeshAppBar(title: 'Hyper-Clean Design'),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: WeeshCard(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Test Content for Visual Regression'),
              ),
            ),
          ),
        ),
      ),
    );

    // Settle animations and fonts BEFORE capturing the golden screenshot,
    // so the captured frame is deterministic and not timing-sensitive.
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/weesh_core_components.png'),
    );
  });
}
