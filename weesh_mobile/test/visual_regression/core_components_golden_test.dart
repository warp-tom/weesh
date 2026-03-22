import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

import 'dart:io';

class _FakeHttpOverrides extends HttpOverrides {
  // Purposefully removed badCertificateCallback to avoid globally disabling TLS checks.
}

void main() {
  setUpAll(() {
    // WeeshAppBar uses GoogleFonts.notoSansJp() which is not a bundled asset.
    // Allow runtime fetching; FakeHttpOverrides handles network gracefully.
    GoogleFonts.config.allowRuntimeFetching = true;
    HttpOverrides.global = _FakeHttpOverrides();
  });

  testWidgets('WeeshCard and WeeshAppBar match golden snapshot', (tester) async {
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

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/weesh_core_components.png'),
    );

    // Clear pending timers from flutter_animate elements inside WeeshCard
    await tester.pump(const Duration(seconds: 1));
  });
}
