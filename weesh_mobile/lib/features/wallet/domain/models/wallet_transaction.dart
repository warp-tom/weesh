import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_transaction.freezed.dart';
part 'wallet_transaction.g.dart';

/// Safely converts Postgres `numeric` (e.g. "500.00") to centavos [int].
int _centavosFromJson(dynamic value) =>
    double.parse(value.toString()).round();

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    @JsonKey(name: 'wallet_id') required String walletId,
    @JsonKey(fromJson: _centavosFromJson) required int amount,
    required String title,
    String? description,
    required String type, // top_up, payment, transfer, refund
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}
