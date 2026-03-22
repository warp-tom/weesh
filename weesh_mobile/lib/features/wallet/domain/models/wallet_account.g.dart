// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletAccountImpl _$$WalletAccountImplFromJson(Map<String, dynamic> json) =>
    _$WalletAccountImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: json['balance'] == null ? 0 : centavosFromJson(json['balance']),
    );

Map<String, dynamic> _$$WalletAccountImplToJson(_$WalletAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'balance': instance.balance,
    };
