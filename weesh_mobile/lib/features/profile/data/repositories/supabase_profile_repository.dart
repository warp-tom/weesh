import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:weesh_mobile/features/profile/domain/repositories/profile_repository.dart';

/// Reusable provider for the ProfileRepository implementation
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository(ref.watch(supabaseProvider));
});

class SupabaseProfileRepository implements ProfileRepository {
  const SupabaseProfileRepository(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    }
  }

  @override
  Future<void> upsertProfile({
    required String userId,
    required String phone,
    required String fullName,
    String? email,
    String? avatarUrl,
  }) async {
    try {
      await _supabase.from('users').upsert({
        'id': userId,
        'phone': phone,
        'full_name': fullName,
        if (email != null && email.isNotEmpty) 'email': email,
        if (avatarUrl != null && avatarUrl.isNotEmpty)
          'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      // In a real app, wrap in domain-specific WeeshNetworkException
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upsert profile: $e');
    }
  }

  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp'};

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final ext = p.extension(imageFile.path).replaceFirst('.', '').toLowerCase();
      final sanitizedExt = ext.isEmpty || !_allowedExtensions.contains(ext) 
          ? 'jpg' 
          : ext;

      final path = '$userId.$sanitizedExt';

      // CRITICAL FIX: The correct bucket name is 'avatars'
      await _supabase.storage.from('avatars').upload(
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl =
          _supabase.storage.from('avatars').getPublicUrl(path);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Storage error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  @override
  Future<void> linkGcash({
    required String userId,
    required String gcashNumber,
  }) async {
    try {
      await _supabase.from('users').update({
        'gcash_number': gcashNumber,
        'gcash_linked_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to link GCash: $e');
    }
  }
}
