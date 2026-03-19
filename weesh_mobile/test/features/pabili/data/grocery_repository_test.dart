import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/pabili/data/grocery_repository.dart';
import 'package:weesh_mobile/features/pabili/data/isar/isar_grocery_order.dart';

void main() {
  late Isar isar;
  late GroceryRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('isar_grocery_test_');
    isar = await Isar.open(
      [IsarGroceryOrderSchema],
      directory: tempDir.path,
    );
    repository = GroceryRepository(AsyncData(isar));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('GroceryRepository tests', () {
    test('saveOrder successfully inserts a new grocery order', () async {
      final order = IsarGroceryOrder()
        ..remoteId = ''
        ..userId = 'user123'
        ..storeName = 'Local Market'
        ..itemList = '1. Rice\n2. Canned goods'
        ..dropLat = 14.6
        ..dropLng = 121.1
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveGroceryOrder(order);

      final orders = await repository.getAllOrders();
      expect(orders.length, 1);
      expect(orders.first.userId, 'user123');
      expect(orders.first.storeName, 'Local Market');
      expect(orders.first.syncStatus, SyncStatus.pending);
    });

    test('getPendingOrders returns only orders with pending SyncStatus', () async {
      final pendingOrder = IsarGroceryOrder()
        ..remoteId = ''
        ..userId = 'user1'
        ..dropLat = 1.0 ..dropLng = 1.0
        ..storeName = 'A' ..itemList = 'A'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      final syncedOrder = IsarGroceryOrder()
        ..userId = 'user2'
        ..dropLat = 1.0 ..dropLng = 1.0
        ..storeName = 'B' ..itemList = 'B'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..remoteId = 'remote1'
        ..syncStatus = SyncStatus.synced;

      await repository.saveGroceryOrder(pendingOrder);
      await repository.saveGroceryOrder(syncedOrder);

      final pendingOrders = await repository.getPendingOrders();
      expect(pendingOrders.length, 1);
      expect(pendingOrders.first.userId, 'user1');
      expect(pendingOrders.first.syncStatus, SyncStatus.pending);
    });

    test('markAsSynced updates remoteId and syncStatus', () async {
      final order = IsarGroceryOrder()
        ..remoteId = ''
        ..userId = 'user_sync'
        ..dropLat = 1.0 ..dropLng = 1.0
        ..storeName = 'Sync Store' ..itemList = 'Test'
        ..createdAt = DateTime.now() ..updatedAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await repository.saveGroceryOrder(order);
      final inserted = (await repository.getPendingOrders()).first;

      await repository.markAsSynced(inserted.id, 'uuid-abc');

      final updatedOrders = await repository.getAllOrders();
      final updated = updatedOrders.firstWhere((o) => o.id == inserted.id);

      expect(updated.syncStatus, SyncStatus.synced);
      expect(updated.remoteId, 'uuid-abc');
      
      final pendingOrders = await repository.getPendingOrders();
      expect(pendingOrders.isEmpty, true);
    });
  });
}
