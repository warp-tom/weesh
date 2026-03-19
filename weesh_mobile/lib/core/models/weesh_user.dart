import 'package:freezed_annotation/freezed_annotation.dart';

part 'weesh_user.freezed.dart';
part 'weesh_user.g.dart';

@freezed
class WeeshUser with _$WeeshUser {
  const factory WeeshUser({
    required String id,
    String? phone,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'tag_rating') @Default('Baguhan (Newbie)') String tagRating,
    @JsonKey(name: 'preferred_mode') @Default('customer') String preferredMode,
    String? city,
    String? province,
    @Default('customer') String role,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WeeshUser;

  factory WeeshUser.fromJson(Map<String, dynamic> json) =>
      _$WeeshUserFromJson(json);
}
