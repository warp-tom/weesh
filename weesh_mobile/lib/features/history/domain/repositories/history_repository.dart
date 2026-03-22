import 'package:weesh_mobile/features/history/domain/models/activity.dart';

abstract class HistoryRepository {
  Future<List<Activity>> getActiveActivities(String userId);
  Future<List<Activity>> getPastActivities(String userId);
}
