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
  CartNotifier() : super([
    // Initial mock data to match current UI
    CartItem(
      id: '1',
      name: 'Pancit Canton (Original)',
      price: 40.0,
      quantity: 2,
      imageUrl: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?auto=format&fit=crop&q=80&w=150',
      customization: 'Extra spicy please',
    ),
    CartItem(
      id: '2',
      name: 'Cobra Energy Drink',
      price: 25.0,
      quantity: 1,
      imageUrl: 'https://images.unsplash.com/photo-1622542796254-54f0582caaf7?auto=format&fit=crop&q=80&w=150',
    ),
    CartItem(
      id: '3',
      name: 'Gardenia Loaf Bread',
      price: 85.0,
      quantity: 1,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&q=80&w=150',
    ),
  ]);

  void addItem(CartItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void updateQuantity(String id, int delta) {
    state = [
      for (final item in state)
        if (item.id == id)
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
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
});
