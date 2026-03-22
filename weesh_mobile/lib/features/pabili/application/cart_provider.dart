import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String? customization;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.customization,
  });

  String get lineItemKey => '${id}_${customization ?? ''}';

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      customization: customization,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final idx = state.indexWhere((existing) => existing.lineItemKey == item.lineItemKey);
    if (idx >= 0) {
      // Intentional additive behavior: if user adds the same item with qty=3, and 2 exist, new total is 5.
      updateQuantity(item.lineItemKey, item.quantity);
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String lineItemKey) {
    state = state.where((item) => item.lineItemKey != lineItemKey).toList();
  }

  void updateQuantity(String lineItemKey, int delta) {
    state = [
      for (final item in state)
        if (item.lineItemKey == lineItemKey)
          item.copyWith(quantity: (item.quantity + delta).clamp(1, 99))
        else
          item,
    ];
  }

  void clear() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider.notifier).subtotal;
});
