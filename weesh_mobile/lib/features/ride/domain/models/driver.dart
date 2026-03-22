import 'package:flutter/foundation.dart';

@immutable
class Driver {
  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.vehicleType,
    this.photoUrl,
    this.plateNumber,
    this.currentLat,
    this.currentLng,
  });

  final String id;
  final String name;
  final double rating;
  final String vehicleType;
  final String? photoUrl;
  final String? plateNumber;
  final double? currentLat;
  final double? currentLng;

  factory Driver.fromMap(Map<String, dynamic> m) => Driver(
        id: m['id'] as String,
        name: m['name'] as String,
        rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
        vehicleType: m['vehicle_type'] as String? ?? 'motorcycle',
        photoUrl: m['photo_url'] as String?,
        plateNumber: m['plate_number'] as String?,
        currentLat: m['current_lat'] != null ? (m['current_lat'] as num).toDouble() : null,
        currentLng: m['current_lng'] != null ? (m['current_lng'] as num).toDouble() : null,
      );
}
