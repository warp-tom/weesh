// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weesh_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeshUser _$WeeshUserFromJson(Map<String, dynamic> json) {
  return _WeeshUser.fromJson(json);
}

/// @nodoc
mixin _$WeeshUser {
  String get id => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'tag_rating')
  String get tagRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_mode')
  String get preferredMode => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeshUserCopyWith<WeeshUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeshUserCopyWith<$Res> {
  factory $WeeshUserCopyWith(WeeshUser value, $Res Function(WeeshUser) then) =
      _$WeeshUserCopyWithImpl<$Res, WeeshUser>;
  @useResult
  $Res call(
      {String id,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'tag_rating') String tagRating,
      @JsonKey(name: 'preferred_mode') String preferredMode,
      String? city,
      String? province,
      String role,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$WeeshUserCopyWithImpl<$Res, $Val extends WeeshUser>
    implements $WeeshUserCopyWith<$Res> {
  _$WeeshUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? avatarUrl = freezed,
    Object? tagRating = null,
    Object? preferredMode = null,
    Object? city = freezed,
    Object? province = freezed,
    Object? role = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tagRating: null == tagRating
          ? _value.tagRating
          : tagRating // ignore: cast_nullable_to_non_nullable
              as String,
      preferredMode: null == preferredMode
          ? _value.preferredMode
          : preferredMode // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeshUserImplCopyWith<$Res>
    implements $WeeshUserCopyWith<$Res> {
  factory _$$WeeshUserImplCopyWith(
          _$WeeshUserImpl value, $Res Function(_$WeeshUserImpl) then) =
      __$$WeeshUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'tag_rating') String tagRating,
      @JsonKey(name: 'preferred_mode') String preferredMode,
      String? city,
      String? province,
      String role,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$WeeshUserImplCopyWithImpl<$Res>
    extends _$WeeshUserCopyWithImpl<$Res, _$WeeshUserImpl>
    implements _$$WeeshUserImplCopyWith<$Res> {
  __$$WeeshUserImplCopyWithImpl(
      _$WeeshUserImpl _value, $Res Function(_$WeeshUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? avatarUrl = freezed,
    Object? tagRating = null,
    Object? preferredMode = null,
    Object? city = freezed,
    Object? province = freezed,
    Object? role = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WeeshUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tagRating: null == tagRating
          ? _value.tagRating
          : tagRating // ignore: cast_nullable_to_non_nullable
              as String,
      preferredMode: null == preferredMode
          ? _value.preferredMode
          : preferredMode // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeshUserImpl implements _WeeshUser {
  const _$WeeshUserImpl(
      {required this.id,
      this.phone,
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'tag_rating') this.tagRating = 'Baguhan (Newbie)',
      @JsonKey(name: 'preferred_mode') this.preferredMode = 'customer',
      this.city,
      this.province,
      this.role = 'customer',
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$WeeshUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeshUserImplFromJson(json);

  @override
  final String id;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'tag_rating')
  final String tagRating;
  @override
  @JsonKey(name: 'preferred_mode')
  final String preferredMode;
  @override
  final String? city;
  @override
  final String? province;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WeeshUser(id: $id, phone: $phone, fullName: $fullName, avatarUrl: $avatarUrl, tagRating: $tagRating, preferredMode: $preferredMode, city: $city, province: $province, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeshUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.tagRating, tagRating) ||
                other.tagRating == tagRating) &&
            (identical(other.preferredMode, preferredMode) ||
                other.preferredMode == preferredMode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, phone, fullName, avatarUrl,
      tagRating, preferredMode, city, province, role, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeshUserImplCopyWith<_$WeeshUserImpl> get copyWith =>
      __$$WeeshUserImplCopyWithImpl<_$WeeshUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeshUserImplToJson(
      this,
    );
  }
}

abstract class _WeeshUser implements WeeshUser {
  const factory _WeeshUser(
          {required final String id,
          final String? phone,
          @JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'tag_rating') final String tagRating,
          @JsonKey(name: 'preferred_mode') final String preferredMode,
          final String? city,
          final String? province,
          final String role,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$WeeshUserImpl;

  factory _WeeshUser.fromJson(Map<String, dynamic> json) =
      _$WeeshUserImpl.fromJson;

  @override
  String get id;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'tag_rating')
  String get tagRating;
  @override
  @JsonKey(name: 'preferred_mode')
  String get preferredMode;
  @override
  String? get city;
  @override
  String? get province;
  @override
  String get role;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WeeshUserImplCopyWith<_$WeeshUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
