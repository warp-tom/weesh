import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar_service.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/pabili/data/isar/isar_grocery_order.dart';

final groceryRepositoryProvider = Provider<GroceryRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return GroceryRepository(isarAsync);
});

class GroceryRepository {
  final AsyncValue<Isar> _isarAsync;

  GroceryRepository(this._isarAsync);

  Future<void> saveGroceryOrder(IsarGroceryOrder order) async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    await isar.writeTxn(() async {
      await isar.isarGroceryOrders.put(order);
    });
  }

  Future<List<IsarGroceryOrder>> getPendingOrders() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarGroceryOrders
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  Future<List<IsarGroceryOrder>> getAllOrders() async {
    final isar = _isarAsync.value;
    if (isar == null) {
      throw Exception('Isar database is not initialized');
    }

    return await isar.isarGroceryOrders.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> markAsSynced(int localId, String remoteId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final order = await isar.isarGroceryOrders.get(localId);
    if (order != null) {
      order.remoteId = remoteId;
      order.syncStatus = SyncStatus.synced;
      await isar.writeTxn(() async {
        await isar.isarGroceryOrders.put(order);
      });
    }
  }

  Future<void> markAsFailed(int localId) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    final order = await isar.isarGroceryOrders.get(localId);
    if (order != null) {
      order.syncStatus = SyncStatus.failed;
      await isar.writeTxn(() async {
        await isar.isarGroceryOrders.put(order);
      });
    }
  }
}
