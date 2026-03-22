import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/features/wallet/domain/models/wallet_account.dart';
import 'package:weesh_mobile/features/wallet/domain/models/wallet_transaction.dart';
import 'package:weesh_mobile/features/wallet/domain/repositories/wallet_repository.dart';

class SupabaseWalletRepository implements WalletRepository {
  final SupabaseClient _client;

  SupabaseWalletRepository(this._client);

  @override
  Future<WalletAccount> getOrCreateWallet(String userId) async {
    try {
      final response = await _client
          .from('wallet_accounts')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return WalletAccount.fromJson(response);
      }

      // Create new wallet if none exists
      final newWallet = await _client
          .from('wallet_accounts')
          .insert({'user_id': userId})
          .select()
          .single();

      return WalletAccount.fromJson(newWallet);
    } catch (e) {
      throw Exception('Failed to get or create wallet: $e');
    }
  }

  @override
  Future<List<WalletTransaction>> getRecentTransactions(String walletId) async {
    try {
      final response = await _client
          .from('wallet_transactions')
          .select()
          .eq('wallet_id', walletId)
          .order('created_at', ascending: false)
          .limit(10);

      return (response as List).map((e) => WalletTransaction.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<void> topUpWallet(String walletId, double amount, String source) async {
    try {
      // Call the secure Edge Function instead of direct DB writes
      // The EF handles atomic balance update + transaction record atomically
      final response = await _client.functions.invoke(
        'wallet-topup',
        body: {'amount': amount, 'source': source},
      );

      if (response.status != 200) {
        final body = response.data as Map<String, dynamic>?;
        final errorMsg = body?['error'] as String? ?? 'Top-up failed';
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('Failed to top up wallet: $e');
    }
  }
}
