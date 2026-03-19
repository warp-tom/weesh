import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar_service.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  final supabase = ref.watch(supabaseProvider);
  return RideRepository(isarAsync, supabase);
});

class RideRepository {
  final AsyncValue<Isar> _isarAsync;
  final SupabaseClient _supabase;
  final bool disableBackgroundSync;

  RideRepository(this._isarAsync, this._supabase, {this.disableBackgroundSync = false});

  Future<void> saveRide(IsarRide ride, {void Function(SyncStatus)? onSyncComplete}) async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    await isar.writeTxn(() async {
      await isar.isarRides.put(ride);
    });

    if (!disableBackgroundSync) {
      unawaited(_syncToSupabase(ride, onSyncComplete));
    } else {
      onSyncComplete?.call(ride.syncStatus);
    }
  }

  Future<void> _syncToSupabase(IsarRide ride, void Function(SyncStatus)? onSyncComplete) async {
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
      final isar = _isarAsync.value;
      if (isar != null) {
        await isar.writeTxn(() async {
          ride.remoteId = remoteId;
          ride.syncStatus = SyncStatus.synced;
          await isar.isarRides.put(ride);
        });
      }
      onSyncComplete?.call(SyncStatus.synced);
    } catch (e, stackTrace) {
      debugPrint('Failed to sync ride ${ride.id} to Supabase: $e\n$stackTrace');
      final isar = _isarAsync.value;
      if (isar != null) {
        await isar.writeTxn(() async {
          ride.syncStatus = SyncStatus.failed;
          await isar.isarRides.put(ride);
        });
      }
      onSyncComplete?.call(SyncStatus.failed);
    }
  }

  Future<List<IsarRide>> getPendingRides() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarRides
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  Future<List<IsarRide>> getAllRides() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarRides.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> updateSyncStatus(Id id, SyncStatus status) async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    final ride = await isar.isarRides.get(id);
    if (ride != null) {
      ride.syncStatus = status;
      await isar.writeTxn(() async {
        await isar.isarRides.put(ride);
      });
    }
  }

  Future<void> markAsSynced(int localId, String remoteId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final ride = await isar.isarRides.get(localId);
    if (ride != null) {
      ride.remoteId = remoteId;
      ride.syncStatus = SyncStatus.synced;
      await isar.writeTxn(() async {
        await isar.isarRides.put(ride);
      });
    }
  }

  Future<void> markAsFailed(int localId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final ride = await isar.isarRides.get(localId);
    if (ride != null) {
      ride.syncStatus = SyncStatus.failed;
      await isar.writeTxn(() async {
        await isar.isarRides.put(ride);
      });
    }
  }
}
