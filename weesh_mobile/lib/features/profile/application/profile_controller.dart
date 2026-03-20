import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/features/profile/data/repositories/supabase_profile_repository.dart';

final profileControllerProvider = AsyncNotifierProvider<ProfileController, void>(ProfileController.new);

class ProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Controller doesn't hold ongoing profile state for now, 
    // it just executes the setup command and exposes Loading/Error states.
    return null;
  }

  /// Handles uploading the avatar and upserting the user profile.
  Future<void> setupProfile({
    required String userId,
    required String phone,
    required String fullName,
    String? email,
    File? avatarFile,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      
      String? avatarUrl;
      // 1. Upload avatar if selected
      if (avatarFile != null) {
        avatarUrl = await repository.uploadAvatar(
          userId: userId,
          imageFile: avatarFile,
        );
      }

      // 2. Upsert profile
      await repository.upsertProfile(
        userId: userId,
        phone: phone,
        fullName: fullName,
        email: email,
        avatarUrl: avatarUrl,
      );
    });
  }
}
