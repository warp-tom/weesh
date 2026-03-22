// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletAccount _$WalletAccountFromJson(Map<String, dynamic> json) {
  return _WalletAccount.fromJson(json);
}

/// @nodoc
mixin _$WalletAccount {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletAccountCopyWith<WalletAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletAccountCopyWith<$Res> {
  factory $WalletAccountCopyWith(
          WalletAccount value, $Res Function(WalletAccount) then) =
      _$WalletAccountCopyWithImpl<$Res, WalletAccount>;
  @useResult
  $Res call(
      {String id, @JsonKey(name: 'user_id') String userId, double balance});
}

/// @nodoc
class _$WalletAccountCopyWithImpl<$Res, $Val extends WalletAccount>
    implements $WalletAccountCopyWith<$Res> {
  _$WalletAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletAccountImplCopyWith<$Res>
    implements $WalletAccountCopyWith<$Res> {
  factory _$$WalletAccountImplCopyWith(
          _$WalletAccountImpl value, $Res Function(_$WalletAccountImpl) then) =
      __$$WalletAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, @JsonKey(name: 'user_id') String userId, double balance});
}

/// @nodoc
class __$$WalletAccountImplCopyWithImpl<$Res>
    extends _$WalletAccountCopyWithImpl<$Res, _$WalletAccountImpl>
    implements _$$WalletAccountImplCopyWith<$Res> {
  __$$WalletAccountImplCopyWithImpl(
      _$WalletAccountImpl _value, $Res Function(_$WalletAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? balance = null,
  }) {
    return _then(_$WalletAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletAccountImpl implements _WalletAccount {
  const _$WalletAccountImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      this.balance = 0.0});

  factory _$WalletAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletAccountImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final double balance;

  @override
  String toString() {
    return 'WalletAccount(id: $id, userId: $userId, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, balance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletAccountImplCopyWith<_$WalletAccountImpl> get copyWith =>
      __$$WalletAccountImplCopyWithImpl<_$WalletAccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletAccountImplToJson(
      this,
    );
  }
}

abstract class _WalletAccount implements WalletAccount {
  const factory _WalletAccount(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      final double balance}) = _$WalletAccountImpl;

  factory _WalletAccount.fromJson(Map<String, dynamic> json) =
      _$WalletAccountImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  double get balance;
  @override
  @JsonKey(ignore: true)
  _$$WalletAccountImplCopyWith<_$WalletAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
