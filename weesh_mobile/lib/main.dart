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
    // Show a visible error instead of a silent native-splash freeze.
    // A bare `throw` before runApp() is swallowed by the engine on device.
    runApp(const _CredentialErrorApp());
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  // Initialise push notification channels
  await NotificationService.init();

  runApp(const ProviderScope(child: WeeshApp()));
}

/// Shown when the APK is built without --dart-define-from-file=.env.local.
/// Makes the missing-credential failure immediately visible on device.
class _CredentialErrorApp extends StatelessWidget {
  const _CredentialErrorApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0A0A0F),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 64),
                SizedBox(height: 24),
                Text(
                  'Configuration Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'The app was built without Supabase credentials.\n\n'
                  'To run:\n  flutter run --dart-define-from-file=.env.local\n\n'
                  'To build:\n  flutter build apk --debug \\\n    --dart-define-from-file=.env.local',
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
        const bool enableAccessibilityTools =
            bool.fromEnvironment('ENABLE_A11Y_TOOLS');
        if (enableAccessibilityTools && kDebugMode && child != null) {
          return AccessibilityTools(child: child);
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
