import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/features/history/domain/models/activity.dart';
import 'package:weesh_mobile/features/history/domain/repositories/history_repository.dart';

class SupabaseHistoryRepository implements HistoryRepository {
  final SupabaseClient _client;

  SupabaseHistoryRepository(this._client);

  @override
  Future<List<Activity>> getActiveActivities(String userId) async {
    try {
      final response = await _client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['Pending', 'In Transit'])
          .order('created_at', ascending: false);

      return (response as List).map((e) => Activity.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch active activities: $e');
    }
  }

  @override
  Future<List<Activity>> getPastActivities(String userId) async {
    try {
      final response = await _client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['Completed', 'Cancelled'])
          .order('created_at', ascending: false);

      return (response as List).map((e) => Activity.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch past activities: $e');
    }
  }
}
