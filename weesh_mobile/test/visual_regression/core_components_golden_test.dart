import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
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
  });
}
