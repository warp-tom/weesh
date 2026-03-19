import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/ride/data/ride_repository.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<Map<String, dynamic>> {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder<Map<String, dynamic>> {}

void main() {
  late Isar isar;
  late RideRepository repository;
  late MockSupabaseClient mockSupabase;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    registerFallbackValue(IsarRide());
  });

  setUp(() async {
    mockSupabase = MockSupabaseClient();
    tempDir = Directory.systemTemp.createTempSync('isar_ride_test_');
    isar = await Isar.open(
      [IsarRideSchema],
      directory: tempDir.path,
    );
    // Disable background sync by default for base tests
    repository = RideRepository(AsyncData(isar), mockSupabase, disableBackgroundSync: true);
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

    test('saveRide with background sync enabled updates to synced on success', () async {
      final syncRepo = RideRepository(AsyncData(isar), mockSupabase, disableBackgroundSync: false);
      
      final ride = IsarRide()
        ..userId = 'sync_user_success'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      final mockQuery = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();
      final mockTransform = MockPostgrestTransformBuilder();

      when(() => mockSupabase.from('weesh_rides')).thenReturn(mockQuery);
      when(() => (mockQuery as dynamic).insert(any())).thenReturn(mockFilter);
      when(() => (mockFilter as dynamic).select()).thenReturn(mockFilter);
      when(() => (mockFilter as dynamic).single()).thenReturn(mockTransform);
      when(() => (mockTransform as dynamic).then(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as FutureOr<Map<String, dynamic>> Function(Map<String, dynamic>);
        return callback({'id': 'remote-123'});
      });

      final completer = Completer<SyncStatus>();
      await syncRepo.saveRide(ride, onSyncComplete: (status) {
        if (!completer.isCompleted) completer.complete(status);
      });

      final finalStatus = await completer.future;
      expect(finalStatus, SyncStatus.synced);

      final allRides = await syncRepo.getAllRides();
      expect(allRides.first.syncStatus, SyncStatus.synced);
      expect(allRides.first.remoteId, 'remote-123');
    });

    test('saveRide with background sync enabled updates to failed on error', () async {
      final syncRepo = RideRepository(AsyncData(isar), mockSupabase, disableBackgroundSync: false);
      
      final ride = IsarRide()
        ..userId = 'sync_user_fail'
        ..pickupLat = 1.0 ..pickupLng = 1.0 ..dropLat = 1.0 ..dropLng = 1.0
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      final mockQuery = MockSupabaseQueryBuilder();

      when(() => mockSupabase.from(any())).thenReturn(mockQuery);
      when(() => (mockQuery as dynamic).insert(any())).thenThrow(Exception('Supabase connection lost'));

      final completer = Completer<SyncStatus>();
      await syncRepo.saveRide(ride, onSyncComplete: (status) {
        if (!completer.isCompleted) completer.complete(status);
      });

      final finalStatus = await completer.future;
      expect(finalStatus, SyncStatus.failed);

      final allRides = await syncRepo.getAllRides();
      expect(allRides.first.syncStatus, SyncStatus.failed);
    });
  });
}
