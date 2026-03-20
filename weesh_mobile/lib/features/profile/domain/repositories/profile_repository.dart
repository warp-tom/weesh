import 'dart:io';

/// Defines the contract for fetching and updating user profiles,
/// as well as uploading avatars to the backend storage.
abstract class ProfileRepository {
  /// Upserts the user profile data.
  /// 
  /// The [userId] must match the authenticated user.
  /// Allowed fields include 'full_name', 'email', 'avatar_url', etc.
  Future<void> upsertProfile({
    required String userId,
    required String phone,
    required String fullName,
    String? email,
    String? avatarUrl,
  });

  /// Uploads an avatar image and returns the public URL.
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  });
}
