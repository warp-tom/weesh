import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weesh_mobile/features/home/presentation/screens/home_screen.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/ride/application/ride_sync_service.dart';
import 'package:weesh_mobile/features/parcel/application/parcel_sync_service.dart';
import 'package:weesh_mobile/features/pabili/application/grocery_sync_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}


class MockRideSync extends Mock implements RideSyncService {}
class MockParcelSync extends Mock implements ParcelSyncService {}
class MockGrocerySync extends Mock implements GrocerySyncService {}
class MockSupabaseClient extends Mock implements SupabaseClient {}

class _FakeGuestAuthController extends AsyncNotifier<User?> implements AuthController {
  @override
  Future<User?> build() async {
    return _FakeUser();
  }
  @override
  Future<void> signInWithPhone(String phone) async {}
  @override
  Future<void> verifyOtp(String phone, String otp) async {}
  @override
  Future<void> signOut() async {}
}

class _FakeUser extends Mock implements User {
  @override
  Map<String, dynamic>? get userMetadata => {'full_name': 'Guest User'};
  @override
  String get id => 'fake-uuid-123';
}

void main() {
  setUpAll(() async {
    // Let it "fetch", but HttpOverrides will stop actual network errors from breaking the test harness
    GoogleFonts.config.allowRuntimeFetching = true; 
    HttpOverrides.global = _FakeHttpOverrides();
    
    // Completely mock the platform views channel to bypass Mapbox rendering crashes
    const MethodChannel channel = MethodChannel('flutter/platform_views');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  testWidgets('HomeScreen passes strict UI/UX Accessibility Guidelines', (WidgetTester tester) async {
    // 1. Pump your screen into the test environment (with ProviderScope for Riverpod)
    final mockRideSync = MockRideSync();
    when(() => mockRideSync.syncPendingRides()).thenAnswer((_) async {});

    final mockParcelSync = MockParcelSync();
    when(() => mockParcelSync.syncPendingParcels()).thenAnswer((_) async {});

    final mockGrocerySync = MockGrocerySync();
    when(() => mockGrocerySync.syncPendingOrders()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(() => _FakeGuestAuthController()),
          authStateProvider.overrideWith((ref) => const Stream.empty()),
          supabaseProvider.overrideWithValue(MockSupabaseClient()),
          rideSyncServiceProvider.overrideWithValue(mockRideSync),
          parcelSyncServiceProvider.overrideWithValue(mockParcelSync),
          grocerySyncServiceProvider.overrideWithValue(mockGrocerySync),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      )
    );
    await tester.pump(); // single frame, avoids hanging on Mapbox platform streaming

    // 2. Check for muddy colors / contrast issues mathematically
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    
    // 3. Check for UX friction (buttons too small to tap)
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Clear any pending timers from flutter_animate delays before test tearDown
    await tester.pump(const Duration(seconds: 1));
  });
}
