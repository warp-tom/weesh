import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/core/router/router.dart';
import 'package:weesh_mobile/core/services/notification_service.dart';
import 'package:weesh_mobile/core/theme/app_theme.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/foundation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    throw Exception(
      'Missing Supabase credentials! Please restart the app using:\n'
      'flutter run --dart-define-from-file=.env.local',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  // Initialise push notification channels
  await NotificationService.init();

  runApp(const ProviderScope(child: WeeshApp()));
}


class WeeshApp extends StatelessWidget {
  const WeeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weesh',
      theme: appTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        const bool enableAccessibilityTools = false;
        // ignore: dead_code
        if (enableAccessibilityTools && kDebugMode && child != null) {
          return AccessibilityTools(child: child);
        }
        return child!;
      },
    );
  }
}
