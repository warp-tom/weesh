import 'package:flutter/foundation.dart';

enum RideStatus { pending, assigned, inProgress, completed, cancelled }

class _Sentinel {
  const _Sentinel();
}
const _sentinel = _Sentinel();

@immutable
class Ride {
  const Ride({
    required this.id,
    required this.userId,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.status,
    required this.createdAt,
    this.driverId,
    this.otp,
    this.fare,
    this.vehicleType = 'motorcycle',
  });

  final String id;
  final String userId;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final RideStatus status;
  final DateTime createdAt;
  final String? driverId;
  final String? otp;
  final double? fare;
  final String vehicleType;

  static RideStatus _parseStatus(String s) => switch (s) {
        'assigned' => RideStatus.assigned,
        'in_progress' => RideStatus.inProgress,
        'completed' => RideStatus.completed,
        'cancelled' => RideStatus.cancelled,
        _ => RideStatus.pending,
      };

  factory Ride.fromMap(Map<String, dynamic> m) => Ride(
        id: m['id'] as String,
        userId: m['user_id'] as String,
        pickupLat: (m['pickup_lat'] as num).toDouble(),
        pickupLng: (m['pickup_lng'] as num).toDouble(),
        dropLat: (m['drop_lat'] as num).toDouble(),
        dropLng: (m['drop_lng'] as num).toDouble(),
        status: _parseStatus(m['status'] as String? ?? 'pending'),
        createdAt: DateTime.parse(m['created_at'] as String),
        driverId: m['driver_id'] as String?,
        otp: m['otp'] as String?,
        fare: m['fare'] != null ? (m['fare'] as num).toDouble() : null,
        vehicleType: m['vehicle_type'] as String? ?? 'motorcycle',
      );

  Ride copyWith({
    Object? driverId = _sentinel,
    Object? status = _sentinel,
    Object? otp = _sentinel,
    Object? fare = _sentinel,
  }) =>
      Ride(
        id: id,
        userId: userId,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        status: status == _sentinel ? this.status : status as RideStatus,
        createdAt: createdAt,
        driverId: driverId == _sentinel ? this.driverId : driverId as String?,
        otp: otp == _sentinel ? this.otp : otp as String?,
        fare: fare == _sentinel ? this.fare : fare as double?,
        vehicleType: vehicleType,
      );
}
