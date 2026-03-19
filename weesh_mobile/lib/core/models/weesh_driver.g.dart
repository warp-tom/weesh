// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weesh_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeshDriverImpl _$$WeeshDriverImplFromJson(Map<String, dynamic> json) =>
    _$WeeshDriverImpl(
      id: json['id'] as String,
      vehicleType: json['vehicle_type'] as String? ?? 'tricycle',
      plateNumber: json['plate_number'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
      activeServices: (json['active_services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['ride'],
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 5.0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
    );

Map<String, dynamic> _$$WeeshDriverImplToJson(_$WeeshDriverImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_type': instance.vehicleType,
      'plate_number': instance.plateNumber,
      'is_online': instance.isOnline,
      'active_services': instance.activeServices,
      'rating_avg': instance.ratingAvg,
      'rating_count': instance.ratingCount,
      'last_seen_at': instance.lastSeenAt?.toIso8601String(),
    };
