import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_driver/core/router/app_router.dart';

// Ensure these constants exist or are passed via --dart-define
const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl.isNotEmpty ? supabaseUrl : 'https://placeholder.supabase.co',
    anonKey: supabaseAnonKey.isNotEmpty ? supabaseAnonKey : 'placeholder-key',
  );

  runApp(
    const ProviderScope(
      child: WeeshDriverApp(),
    ),
  );
}

class WeeshDriverApp extends ConsumerWidget {
  const WeeshDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Weesh Driver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
