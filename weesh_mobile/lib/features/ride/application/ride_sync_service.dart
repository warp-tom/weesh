import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:weesh_mobile/features/ride/data/ride_repository.dart';

final rideSyncServiceProvider = Provider<RideSyncService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final rideRepo = ref.watch(rideRepositoryProvider);
  return RideSyncService(supabase, rideRepo);
});

class RideSyncService {
  final SupabaseClient _supabase;
  final RideRepository _rideRepo;

  RideSyncService(this._supabase, this._rideRepo);

  Future<void> syncPendingRides() async {
    try {
      final pendingRides = await _rideRepo.getPendingRides();

      if (pendingRides.isEmpty) return;

      for (var ride in pendingRides) {
        try {
          final response = await _supabase
              .from('weesh_rides')
              .insert({
                'user_id': ride.userId,
                'pickup_lat': ride.pickupLat,
                'pickup_lng': ride.pickupLng,
                'drop_lat': ride.dropLat,
                'drop_lng': ride.dropLng,
                'status': 'pending',
              })
              .select()
              .single();

          final remoteId = response['id'] as String;
          await _rideRepo.markAsSynced(ride.id, remoteId);
        } catch (e) {
          await _rideRepo.markAsFailed(ride.id);
        }
      }
    } catch (e) {
      // General error
    }
  }
}
