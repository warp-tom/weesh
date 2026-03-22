import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:weesh_mobile/core/utils/currency_utils.dart';

part 'wallet_transaction.freezed.dart';
part 'wallet_transaction.g.dart';

@JsonEnum()
enum WalletTransactionType {
  @JsonValue('top_up')
  topUp,
  @JsonValue('payment')
  payment,
  @JsonValue('transfer')
  transfer,
  @JsonValue('refund')
  refund,
}

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    @JsonKey(name: 'wallet_id') required String walletId,
    @JsonKey(fromJson: centavosFromJson) required int amount,
    required String title,
    String? description,
    required WalletTransactionType type,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}
