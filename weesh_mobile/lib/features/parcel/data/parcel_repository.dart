import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar_service.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/parcel/data/isar/isar_parcel.dart';

final parcelRepositoryProvider = Provider<ParcelRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return ParcelRepository(isarAsync);
});

class ParcelRepository {
  final AsyncValue<Isar> _isarAsync;

  ParcelRepository(this._isarAsync);

  Future<void> saveParcel(IsarParcel parcel) async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    await isar.writeTxn(() async {
      await isar.isarParcels.put(parcel);
    });
  }

  Future<List<IsarParcel>> getPendingParcels() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarParcels
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  Future<List<IsarParcel>> getAllParcels() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarParcels.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> markAsSynced(int localId, String remoteId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final parcel = await isar.isarParcels.get(localId);
    if (parcel != null) {
      parcel.remoteId = remoteId;
      parcel.syncStatus = SyncStatus.synced;
      await isar.writeTxn(() async {
        await isar.isarParcels.put(parcel);
      });
    }
  }

  Future<void> markAsFailed(int localId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final parcel = await isar.isarParcels.get(localId);
    if (parcel != null) {
      parcel.syncStatus = SyncStatus.failed;
      await isar.writeTxn(() async {
        await isar.isarParcels.put(parcel);
      });
    }
  }
}
