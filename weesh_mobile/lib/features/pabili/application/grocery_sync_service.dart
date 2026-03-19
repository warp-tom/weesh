import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';
import 'package:weesh_mobile/features/pabili/data/grocery_repository.dart';

final grocerySyncServiceProvider = Provider<GrocerySyncService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final groceryRepo = ref.watch(groceryRepositoryProvider);
  return GrocerySyncService(supabase, groceryRepo);
});

class GrocerySyncService {
  final SupabaseClient _supabase;
  final GroceryRepository _groceryRepo;

  GrocerySyncService(this._supabase, this._groceryRepo);

  Future<void> syncPendingOrders() async {
    try {
      final pendingOrders = await _groceryRepo.getPendingOrders();

      if (pendingOrders.isEmpty) return;

      for (var order in pendingOrders) {
        try {
          final response = await _supabase
              .from('weesh_grocery_orders')
              .insert({
                'user_id': order.userId,
                'store_name': order.storeName,
                'item_list': order.itemList,
                'drop_lat': order.dropLat,
                'drop_lng': order.dropLng,
                'status': 'pending',
              })
              .select()
              .single();

          final remoteId = response['id'] as String;
          await _groceryRepo.markAsSynced(order.id, remoteId);
        } catch (e) {
          await _groceryRepo.markAsFailed(order.id);
        }
      }
    } catch (e) {
      // General error
    }
  }
}
