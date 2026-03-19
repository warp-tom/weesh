import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_controller.g.dart';

// Role selection is no longer used in the customer app

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Stream<AuthState> build() {
    return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
  }

  User? get currentUser => ref.read(supabaseClientProvider).auth.currentUser;

  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await ref
        .read(supabaseClientProvider)
        .auth
        .signInWithPassword(email: email, password: password);
    final user = response.user;
    if (user != null) {
      try {
        await _ensureUserProfile(user: user);
        
        // Ensure user is a driver
        final userData = await ref
            .read(supabaseClientProvider)
            .from('users')
            .select('role')
            .eq('id', user.id)
            .single();
            
        if (userData['role'] != 'driver') {
          throw Exception('This app is for drivers only. Please use the customer app.');
        }
      } catch (error) {
        if (ref.read(supabaseClientProvider).auth.currentSession != null) {
          await signOut();
        }
        rethrow;
      }
    }
    return response.session != null;
  }

  Future<bool> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String vehicleType,
    required String plateNumber,
  }) async {
    final userData = <String, dynamic>{
      'full_name': fullName,
      'role': 'driver',
    };
    final response = await ref
        .read(supabaseClientProvider)
        .auth
        .signUp(email: email, password: password, data: userData);
    final user = response.user;
    if (user != null) {
      try {
        await _ensureUserProfile(
          user: user,
          fullName: fullName,
          vehicleType: vehicleType,
          plateNumber: plateNumber,
        );
      } catch (error) {
        if (ref.read(supabaseClientProvider).auth.currentSession != null) {
          await signOut();
        }
        rethrow;
      }
    }
    return response.session != null;
  }

  Future<void> signOut() async {
    await ref.read(supabaseClientProvider).auth.signOut();
  }



  Future<void> _ensureUserProfile({
    required User user,
    String? fullName,
    String? vehicleType,
    String? plateNumber,
  }) async {
    if (ref.read(supabaseClientProvider).auth.currentSession == null) {
      return;
    }

    try {
      await ref.read(supabaseClientProvider).from('users').upsert({
        'id': user.id,
        'full_name':
            fullName ??
            user.userMetadata?['full_name'] ??
            user.email?.split('@').first,
        'phone': user.phone?.isNotEmpty == true ? user.phone : null,
        'role': 'driver',
        if (vehicleType != null) ...{'vehicle_type': vehicleType},
        if (plateNumber != null) ...{'plate_number': plateNumber},
      });
    } catch (error) {
      debugPrint('Profile bootstrap failed: $error');
    }
  }
}
