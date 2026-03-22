import 'package:weesh_mobile/features/wallet/domain/models/wallet_account.dart';
import 'package:weesh_mobile/features/wallet/domain/models/wallet_transaction.dart';

abstract class WalletRepository {
  Future<WalletAccount> getOrCreateWallet(String userId);
  Future<List<WalletTransaction>> getRecentTransactions(String walletId);
  Future<void> topUpWallet(String walletId, double amount, String source);
}
