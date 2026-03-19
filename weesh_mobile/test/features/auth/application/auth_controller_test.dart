import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockSession extends Mock implements Session {}
class MockUser extends Mock implements User {}
class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late ProviderContainer container;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockSupabase.auth).thenReturn(mockAuth);

    // Provide default stubs for AuthController initialization
    when(() => mockAuth.onAuthStateChange).thenAnswer((_) => const Stream.empty());
    when(() => mockAuth.currentUser).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController tests', () {
    test('signInWithPhone sets loading and calls signInWithOtp', () async {
      when(() => mockAuth.signInWithOtp(phone: any(named: 'phone')))
          .thenAnswer((_) async {});

      final controller = container.read(authControllerProvider.notifier);
      
      final future = controller.signInWithPhone('+639123456789');
      
      // State should immediately be loading
      expect(container.read(authControllerProvider).isLoading, true);
      
      await future;
      
      verify(() => mockAuth.signInWithOtp(phone: '+639123456789')).called(1);
      final finalState = container.read(authControllerProvider);
      expect(finalState.isLoading, false);
      // Because currentUser is null in mock initially
      expect(finalState.value, isNull);
    });

    test('verifyOtp acts correctly and stores returned user', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      
      when(() => mockAuth.verifyOTP(
            phone: any(named: 'phone'),
            token: any(named: 'token'),
            type: OtpType.sms,
          )).thenAnswer((_) async => mockResponse);

      final controller = container.read(authControllerProvider.notifier);
      
      final future = controller.verifyOtp('+639123456789', '123456');
      
      expect(container.read(authControllerProvider).isLoading, true);
      
      await future;
      
      verify(() => mockAuth.verifyOTP(
            phone: '+639123456789',
            token: '123456',
            type: OtpType.sms,
          )).called(1);
          
      final finalState = container.read(authControllerProvider);
      expect(finalState.isLoading, false);
      expect(finalState.value, mockUser);
    });

    test('signOut clears user session', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
      
      final controller = container.read(authControllerProvider.notifier);
      await controller.signOut();
      
      verify(() => mockAuth.signOut()).called(1);
      final state = container.read(authControllerProvider);
      expect(state.value, isNull);
    });
  });
}
