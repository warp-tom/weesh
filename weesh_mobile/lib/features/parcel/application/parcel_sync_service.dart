import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:weesh_mobile/features/parcel/data/parcel_repository.dart';

final parcelSyncServiceProvider = Provider<ParcelSyncService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final parcelRepo = ref.watch(parcelRepositoryProvider);
  return ParcelSyncService(supabase, parcelRepo);
});

class ParcelSyncService {
  final SupabaseClient _supabase;
  final ParcelRepository _parcelRepo;

  ParcelSyncService(this._supabase, this._parcelRepo);

  Future<void> syncPendingParcels() async {
    try {
      final pendingParcels = await _parcelRepo.getPendingParcels();

      if (pendingParcels.isEmpty) return;

      for (var parcel in pendingParcels) {
        try {
          final response = await _supabase
              .from('weesh_parcels')
              .insert({
                'user_id': parcel.userId,
                'pickup_lat': parcel.pickupLat,
                'pickup_lng': parcel.pickupLng,
                'drop_lat': parcel.dropLat,
                'drop_lng': parcel.dropLng,
                'receiver_name': parcel.receiverName,
                'receiver_phone': parcel.receiverPhone,
                'parcel_description': parcel.parcelDescription,
                'status': 'pending',
              })
              .select()
              .single();

          // Unpack the new UI and stamp it back locally
          final remoteId = response['id'] as String;
          await _parcelRepo.markAsSynced(parcel.id, remoteId);
        } catch (e) {
          await _parcelRepo.markAsFailed(parcel.id);
        }
      }
    } catch (e) {
      // Handle broader errors (e.g. Isar failing)
    }
  }
}
