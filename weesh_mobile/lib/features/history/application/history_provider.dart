import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/history/data/repositories/supabase_history_repository.dart';
import 'package:weesh_mobile/features/history/domain/models/activity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/features/history/domain/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return SupabaseHistoryRepository(Supabase.instance.client);
});

final activeActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return [];

  final realData = await ref.read(historyRepositoryProvider).getActiveActivities(user.id);
  
  // If no real data, return some high-quality mock data for demo
  if (realData.isEmpty) {
    return [
      Activity(
        id: 'mock-1',
        userId: user.id,
        type: 'ride',
        title: 'Ride to Greenbelt 5',
        amount: 145.00,
        status: 'In Transit',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        updatedAt: DateTime.now(),
      ),
      Activity(
        id: 'mock-2',
        userId: user.id,
        type: 'pabili',
        title: 'Grocery from SM Makati',
        amount: 842.50,
        status: 'Pending',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
  return realData;
});

final pastActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return [];

  final realData = await ref.read(historyRepositoryProvider).getPastActivities(user.id);

  if (realData.isEmpty) {
    return [
      Activity(
        id: 'mock-3',
        userId: user.id,
        type: 'parcel',
        title: 'Parcel to Quezon City',
        amount: 120.00,
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Activity(
        id: 'mock-4',
        userId: user.id,
        type: 'top_up',
        title: 'Wallet Top-up via GCash',
        amount: 500.00,
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
      Activity(
        id: 'mock-5',
        userId: user.id,
        type: 'ride',
        title: 'Ride to NAIA Terminal 3',
        amount: 320.00,
        status: 'Cancelled',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
  return realData;
});
