import 'dart:io';

/// Defines the contract for fetching and updating user profiles,
/// as well as uploading avatars to the backend storage.
abstract class ProfileRepository {
  /// Fetches the user profile from the database.
  Future<Map<String, dynamic>?> getProfile(String userId);

  /// Upserts the user profile data.
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

  /// Links the user's GCash number to their profile.
  Future<void> linkGcash({
    required String userId,
    required String gcashNumber,
  });
}
