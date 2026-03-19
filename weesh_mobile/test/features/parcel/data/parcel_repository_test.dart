import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/parcel/data/parcel_repository.dart';
import 'package:weesh_mobile/features/parcel/data/isar/isar_parcel.dart';

void main() {
  late Isar isar;
  late ParcelRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('isar_parcel_test_');
    isar = await Isar.open(
      [IsarParcelSchema],
      directory: tempDir.path,
    );
    repository = ParcelRepository(AsyncData(isar));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ParcelRepository tests', () {
    test('saveParcel successfully inserts a new parcel', () async {
      final parcel = IsarParcel()
        ..remoteId = ''
        ..userId = 'user123'
        ..pickupLat = 14.5
        ..pickupLng = 121.0
        ..dropLat = 14.6
        ..dropLng = 121.1
        ..receiverName = 'John Doe'
        ..receiverPhone = '09123456789'
        ..parcelDescription = 'Books'
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveParcel(parcel);

      final parcels = await repository.getAllParcels();
      expect(parcels.length, 1);
      expect(parcels.first.userId, 'user123');
      expect(parcels.first.receiverName, 'John Doe');
      expect(parcels.first.syncStatus, SyncStatus.pending);
    });

    test('getPendingParcels returns only parcels with pending SyncStatus', () async {
      final pendingParcel = IsarParcel()
        ..remoteId = ''
        ..userId = 'user1'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..receiverName = 'A' ..receiverPhone = '1' ..parcelDescription = 'A'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      final syncedParcel = IsarParcel()
        ..userId = 'user2'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..receiverName = 'B' ..receiverPhone = '2' ..parcelDescription = 'B'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..remoteId = 'remote1'
        ..syncStatus = SyncStatus.synced;

      await repository.saveParcel(pendingParcel);
      await repository.saveParcel(syncedParcel);

      final pendingParcels = await repository.getPendingParcels();
      expect(pendingParcels.length, 1);
      expect(pendingParcels.first.userId, 'user1');
      expect(pendingParcels.first.syncStatus, SyncStatus.pending);
    });

    test('markAsSynced updates remoteId and syncStatus', () async {
      final parcel = IsarParcel()
        ..remoteId = ''
        ..userId = 'user_sync'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..receiverName = 'Sync User' ..receiverPhone = '111' ..parcelDescription = 'Test'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveParcel(parcel);
      final inserted = (await repository.getPendingParcels()).first;

      await repository.markAsSynced(inserted.id, 'uuid-abc');

      final updatedParcels = await repository.getAllParcels();
      final updated = updatedParcels.firstWhere((p) => p.id == inserted.id);

      expect(updated.syncStatus, SyncStatus.synced);
      expect(updated.remoteId, 'uuid-abc');
      
      final pendingParcels = await repository.getPendingParcels();
      expect(pendingParcels.isEmpty, true);
    });
  });
}
