// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weesh_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeshUserImpl _$$WeeshUserImplFromJson(Map<String, dynamic> json) =>
    _$WeeshUserImpl(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      tagRating: json['tag_rating'] as String? ?? 'Baguhan (Newbie)',
      preferredMode: json['preferred_mode'] as String? ?? 'customer',
      city: json['city'] as String?,
      province: json['province'] as String?,
      role: json['role'] as String? ?? 'customer',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WeeshUserImplToJson(_$WeeshUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'tag_rating': instance.tagRating,
      'preferred_mode': instance.preferredMode,
      'city': instance.city,
      'province': instance.province,
      'role': instance.role,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
