import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(supabaseProvider).auth.onAuthStateChange;
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    // Listen for auth state changes
    ref.listen(authStateProvider, (_, next) {
      if (next.hasValue) {
        state = AsyncData(next.value?.session?.user);
      }
    });
    return ref.read(supabaseProvider).auth.currentUser;
  }

  Future<void> signInWithPhone(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(supabaseProvider).auth.signInWithOtp(phone: phone);
      return ref.read(supabaseProvider).auth.currentUser;
    });
    if (state.hasError) {
      throw state.error!;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(supabaseProvider).auth.verifyOTP(
            phone: phone,
            token: otp,
            type: OtpType.sms,
          );
      return response.user;
    });
    if (state.hasError) {
      throw state.error!;
    }
  }

  Future<void> signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
    state = const AsyncData(null);
  }
}
