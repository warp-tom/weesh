/// Safely converts dynamic data (often String from Postgres `numeric`) to centavos [int].
/// Used heavily in @JsonKey(fromJson: centavosFromJson)
int centavosFromJson(dynamic value) {
  if (value == null) return 0;
  final str = value.toString();
  if (str.isEmpty || str == 'null') return 0;
  try {
    return double.parse(str).round();
  } catch (e) {
    return 0; // fallback gracefully if completely malformed
  }
}
