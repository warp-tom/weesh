import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:weesh_mobile/core/utils/currency_utils.dart';

part 'wallet_account.freezed.dart';
part 'wallet_account.g.dart';

@freezed
class WalletAccount with _$WalletAccount {
  const factory WalletAccount({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(fromJson: centavosFromJson) @Default(0) int balance,
  }) = _WalletAccount;

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);
}
