import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/wallet/data/repositories/supabase_wallet_repository.dart';
import 'package:weesh_mobile/features/wallet/domain/models/wallet_account.dart';
import 'package:weesh_mobile/features/wallet/domain/models/wallet_transaction.dart';
import 'package:weesh_mobile/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return SupabaseWalletRepository(Supabase.instance.client);
});

final walletAccountNotifierProvider =
    AsyncNotifierProvider<WalletAccountNotifier, WalletAccount?>(WalletAccountNotifier.new);

class WalletAccountNotifier extends AsyncNotifier<WalletAccount?> {
  @override
  FutureOr<WalletAccount?> build() async {
    return _fetchWallet();
  }

  Future<WalletAccount?> _fetchWallet() async {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return null;

    return await ref.read(walletRepositoryProvider).getOrCreateWallet(user.id);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWallet());
  }

  Future<void> topUp(int amount, String source) async {
    final wallet = state.value;
    if (wallet == null) return;

    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      await ref.read(walletRepositoryProvider).topUpWallet(wallet.id, amount, source);
      ref.invalidate(walletTransactionsProvider);
      return _fetchWallet();
    });
    state = next;
    // Rethrow so callers (e.g. CashInScreen) can catch and show an error.
    if (next is AsyncError) {
      Error.throwWithStackTrace(next.error as Object, next.stackTrace ?? StackTrace.current);
    }
  }
}

final walletTransactionsProvider = FutureProvider<List<WalletTransaction>>((ref) async {
  final wallet = await ref.watch(walletAccountNotifierProvider.future);
  if (wallet == null) return [];

  return ref.read(walletRepositoryProvider).getRecentTransactions(wallet.id);
});
