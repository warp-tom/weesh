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
      // Attempt insert first to ensure atomicity and avoid race conditions
      final newWallet = await _client
          .from('wallet_accounts')
          .insert({'user_id': userId})
          .select()
          .single();
      return WalletAccount.fromJson(newWallet);
    } on PostgrestException catch (e) {
      if (e.code == '23505') { // Unique constraint violation (already exists)
        final existingWallet = await _client
            .from('wallet_accounts')
            .select()
            .eq('user_id', userId)
            .single();
        return WalletAccount.fromJson(existingWallet);
      }
      throw Exception('Failed to get or create wallet: ${e.message}');
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
  Future<void> topUpWallet(String walletId, int amount, String source) async {
    try {
      // Call the atomic Postgres RPC instead of an Edge Function.
      // wallet_top_up() inserts the transaction record AND updates balance
      // in a single DB transaction, running under the user's session JWT via RLS.
      await _client.rpc('wallet_top_up', params: {
        'p_wallet_id': walletId,
        'p_amount': amount,
        'p_source': source,
      });
    } on PostgrestException catch (e) {
      throw Exception('Failed to top up wallet: ${e.message}');
    } catch (e) {
      throw Exception('Failed to top up wallet: $e');
    }
  }
}
