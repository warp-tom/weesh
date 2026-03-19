import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar_service.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return RideRepository(isarAsync);
});

class RideRepository {
  final AsyncValue<Isar> _isarAsync;

  RideRepository(this._isarAsync);

  Future<void> saveRide(IsarRide ride) async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    await isar.writeTxn(() async {
      await isar.isarRides.put(ride);
    });
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
