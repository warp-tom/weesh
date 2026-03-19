import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/ride/data/ride_repository.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late Isar isar;
  late RideRepository repository;
  late MockSupabaseClient mockSupabase;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    mockSupabase = MockSupabaseClient();
    when(() => mockSupabase.from(any())).thenThrow(Exception('mock error'));
    tempDir = Directory.systemTemp.createTempSync('isar_ride_test_');
    isar = await Isar.open(
      [IsarRideSchema],
      directory: tempDir.path,
    );
    repository = RideRepository(AsyncData(isar), mockSupabase);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('RideRepository tests', () {
    test('saveRide successfully inserts a new ride', () async {
      final ride = IsarRide()
        ..remoteId = ''
        ..userId = 'user123'
        ..pickupLat = 14.5
        ..pickupLng = 121.0
        ..dropLat = 14.6
        ..dropLng = 121.1
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveRide(ride);

      final rides = await repository.getAllRides();
      expect(rides.length, 1);
      expect(rides.first.userId, 'user123');
      expect(rides.first.syncStatus, SyncStatus.pending);
    });

    test('getPendingRides returns only rides with pending SyncStatus', () async {
      final pendingRide = IsarRide()
        ..remoteId = ''
        ..userId = 'user1'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      final syncedRide = IsarRide()
        ..userId = 'user2'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..remoteId = 'remote1'
        ..syncStatus = SyncStatus.synced;

      await repository.saveRide(pendingRide);
      await repository.saveRide(syncedRide);

      final pendingRides = await repository.getPendingRides();
      expect(pendingRides.length, 1);
      expect(pendingRides.first.userId, 'user1');
      expect(pendingRides.first.syncStatus, SyncStatus.pending);
    });

    test('markAsSynced updates remoteId and syncStatus', () async {
      final ride = IsarRide()
        ..remoteId = ''
        ..userId = 'user_sync'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveRide(ride);
      // Fetch to easily get the auto-generated Isar ID
      final inserted = (await repository.getPendingRides()).first;

      await repository.markAsSynced(inserted.id, 'uuid-abc');

      final updatedRides = await repository.getAllRides();
      final updated = updatedRides.firstWhere((r) => r.id == inserted.id);

      expect(updated.syncStatus, SyncStatus.synced);
      expect(updated.remoteId, 'uuid-abc');
      
      // Make sure it doesn't show up in pending anymore
      final pendingRides = await repository.getPendingRides();
      expect(pendingRides.isEmpty, true);
    });
  });
}
