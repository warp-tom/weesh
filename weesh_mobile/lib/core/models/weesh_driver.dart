import 'package:freezed_annotation/freezed_annotation.dart';

part 'weesh_driver.freezed.dart';
part 'weesh_driver.g.dart';

@freezed
class WeeshDriver with _$WeeshDriver {
  const factory WeeshDriver({
    required String id, // FK to users.id
    @JsonKey(name: 'vehicle_type') @Default('tricycle') String vehicleType,
    @JsonKey(name: 'plate_number') String? plateNumber,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @JsonKey(name: 'active_services')
    @Default(['ride'])
    List<String> activeServices,
    @JsonKey(name: 'rating_avg') @Default(5.0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt,
  }) = _WeeshDriver;

  factory WeeshDriver.fromJson(Map<String, dynamic> json) =>
      _$WeeshDriverFromJson(json);
}
