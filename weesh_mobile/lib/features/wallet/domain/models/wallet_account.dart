import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_account.freezed.dart';
part 'wallet_account.g.dart';

/// Safely converts Postgres `numeric` (e.g. "10000.00") to centavos [int].
int _centavosFromJson(dynamic value) =>
    double.parse(value.toString()).round();

@freezed
class WalletAccount with _$WalletAccount {
  const factory WalletAccount({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(fromJson: _centavosFromJson) @Default(0) int balance,
  }) = _WalletAccount;

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);
}
