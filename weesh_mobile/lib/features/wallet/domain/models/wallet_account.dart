import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_account.freezed.dart';
part 'wallet_account.g.dart';

@freezed
class WalletAccount with _$WalletAccount {
  const factory WalletAccount({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default(0.0) double balance,
  }) = _WalletAccount;

  factory WalletAccount.fromJson(Map<String, dynamic> json) => _$WalletAccountFromJson(json);
}
