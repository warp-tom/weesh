import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Safely converts Postgres `numeric` (e.g. "145.00") to centavos [int].
int _centavosFromJson(dynamic value) =>
    double.parse(value.toString()).round();

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // ride, pabili, parcel, top_up
    required String title,
    // Amount stored in centavos (e.g. 14500 = ₱145.00) matching wallet layer.
    @JsonKey(fromJson: _centavosFromJson) required int amount,
    required String status, // Pending, In Transit, Completed, Cancelled
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

