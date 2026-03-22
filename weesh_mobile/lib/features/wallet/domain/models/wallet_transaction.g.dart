// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletTransactionImpl _$$WalletTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletTransactionImpl(
      id: json['id'] as String,
      walletId: json['wallet_id'] as String,
      amount: _centavosFromJson(json['amount']),
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WalletTransactionImplToJson(
        _$WalletTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_id': instance.walletId,
      'amount': instance.amount,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'created_at': instance.createdAt.toIso8601String(),
    };
