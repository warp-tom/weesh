// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weesh_driver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeshDriver _$WeeshDriverFromJson(Map<String, dynamic> json) {
  return _WeeshDriver.fromJson(json);
}

/// @nodoc
mixin _$WeeshDriver {
  String get id => throw _privateConstructorUsedError; // FK to users.id
  @JsonKey(name: 'vehicle_type')
  String get vehicleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'plate_number')
  String? get plateNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_online')
  bool get isOnline => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_services')
  List<String> get activeServices => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_avg')
  double get ratingAvg => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count')
  int get ratingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_seen_at')
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeshDriverCopyWith<WeeshDriver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeshDriverCopyWith<$Res> {
  factory $WeeshDriverCopyWith(
          WeeshDriver value, $Res Function(WeeshDriver) then) =
      _$WeeshDriverCopyWithImpl<$Res, WeeshDriver>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vehicle_type') String vehicleType,
      @JsonKey(name: 'plate_number') String? plateNumber,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'active_services') List<String> activeServices,
      @JsonKey(name: 'rating_avg') double ratingAvg,
      @JsonKey(name: 'rating_count') int ratingCount,
      @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt});
}

/// @nodoc
class _$WeeshDriverCopyWithImpl<$Res, $Val extends WeeshDriver>
    implements $WeeshDriverCopyWith<$Res> {
  _$WeeshDriverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleType = null,
    Object? plateNumber = freezed,
    Object? isOnline = null,
    Object? activeServices = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleType: null == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      activeServices: null == activeServices
          ? _value.activeServices
          : activeServices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ratingAvg: null == ratingAvg
          ? _value.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeshDriverImplCopyWith<$Res>
    implements $WeeshDriverCopyWith<$Res> {
  factory _$$WeeshDriverImplCopyWith(
          _$WeeshDriverImpl value, $Res Function(_$WeeshDriverImpl) then) =
      __$$WeeshDriverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vehicle_type') String vehicleType,
      @JsonKey(name: 'plate_number') String? plateNumber,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'active_services') List<String> activeServices,
      @JsonKey(name: 'rating_avg') double ratingAvg,
      @JsonKey(name: 'rating_count') int ratingCount,
      @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt});
}

/// @nodoc
class __$$WeeshDriverImplCopyWithImpl<$Res>
    extends _$WeeshDriverCopyWithImpl<$Res, _$WeeshDriverImpl>
    implements _$$WeeshDriverImplCopyWith<$Res> {
  __$$WeeshDriverImplCopyWithImpl(
      _$WeeshDriverImpl _value, $Res Function(_$WeeshDriverImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleType = null,
    Object? plateNumber = freezed,
    Object? isOnline = null,
    Object? activeServices = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_$WeeshDriverImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleType: null == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      activeServices: null == activeServices
          ? _value._activeServices
          : activeServices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ratingAvg: null == ratingAvg
          ? _value.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeshDriverImpl implements _WeeshDriver {
  const _$WeeshDriverImpl(
      {required this.id,
      @JsonKey(name: 'vehicle_type') this.vehicleType = 'tricycle',
      @JsonKey(name: 'plate_number') this.plateNumber,
      @JsonKey(name: 'is_online') this.isOnline = false,
      @JsonKey(name: 'active_services')
      final List<String> activeServices = const ['ride'],
      @JsonKey(name: 'rating_avg') this.ratingAvg = 5.0,
      @JsonKey(name: 'rating_count') this.ratingCount = 0,
      @JsonKey(name: 'last_seen_at') this.lastSeenAt})
      : _activeServices = activeServices;

  factory _$WeeshDriverImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeshDriverImplFromJson(json);

  @override
  final String id;
// FK to users.id
  @override
  @JsonKey(name: 'vehicle_type')
  final String vehicleType;
  @override
  @JsonKey(name: 'plate_number')
  final String? plateNumber;
  @override
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final List<String> _activeServices;
  @override
  @JsonKey(name: 'active_services')
  List<String> get activeServices {
    if (_activeServices is EqualUnmodifiableListView) return _activeServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeServices);
  }

  @override
  @JsonKey(name: 'rating_avg')
  final double ratingAvg;
  @override
  @JsonKey(name: 'rating_count')
  final int ratingCount;
  @override
  @JsonKey(name: 'last_seen_at')
  final DateTime? lastSeenAt;

  @override
  String toString() {
    return 'WeeshDriver(id: $id, vehicleType: $vehicleType, plateNumber: $plateNumber, isOnline: $isOnline, activeServices: $activeServices, ratingAvg: $ratingAvg, ratingCount: $ratingCount, lastSeenAt: $lastSeenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeshDriverImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            const DeepCollectionEquality()
                .equals(other._activeServices, _activeServices) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vehicleType,
      plateNumber,
      isOnline,
      const DeepCollectionEquality().hash(_activeServices),
      ratingAvg,
      ratingCount,
      lastSeenAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeshDriverImplCopyWith<_$WeeshDriverImpl> get copyWith =>
      __$$WeeshDriverImplCopyWithImpl<_$WeeshDriverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeshDriverImplToJson(
      this,
    );
  }
}

abstract class _WeeshDriver implements WeeshDriver {
  const factory _WeeshDriver(
          {required final String id,
          @JsonKey(name: 'vehicle_type') final String vehicleType,
          @JsonKey(name: 'plate_number') final String? plateNumber,
          @JsonKey(name: 'is_online') final bool isOnline,
          @JsonKey(name: 'active_services') final List<String> activeServices,
          @JsonKey(name: 'rating_avg') final double ratingAvg,
          @JsonKey(name: 'rating_count') final int ratingCount,
          @JsonKey(name: 'last_seen_at') final DateTime? lastSeenAt}) =
      _$WeeshDriverImpl;

  factory _WeeshDriver.fromJson(Map<String, dynamic> json) =
      _$WeeshDriverImpl.fromJson;

  @override
  String get id;
  @override // FK to users.id
  @JsonKey(name: 'vehicle_type')
  String get vehicleType;
  @override
  @JsonKey(name: 'plate_number')
  String? get plateNumber;
  @override
  @JsonKey(name: 'is_online')
  bool get isOnline;
  @override
  @JsonKey(name: 'active_services')
  List<String> get activeServices;
  @override
  @JsonKey(name: 'rating_avg')
  double get ratingAvg;
  @override
  @JsonKey(name: 'rating_count')
  int get ratingCount;
  @override
  @JsonKey(name: 'last_seen_at')
  DateTime? get lastSeenAt;
  @override
  @JsonKey(ignore: true)
  _$$WeeshDriverImplCopyWith<_$WeeshDriverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
