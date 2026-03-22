import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/ride/domain/models/driver.dart';

/// The canonical ride type used in the `weeshes` table.
enum WeeshRideStatus { pending, accepted, inProgress, completed, cancelled }

/// Lightweight model for a weesh (ride) record as returned by Supabase.
class WeeshRide {
  const WeeshRide({
    required this.id,
    required this.userId,
    required this.status,
    required this.requestCode,
    required this.createdAt,
    this.driverId,
    this.fare,
    this.pickupLabel,
    this.dropoffLabel,
    this.notes,
  });

  final String id;
  final String userId;
  final WeeshRideStatus status;
  final String requestCode;
  final DateTime createdAt;
  final String? driverId;
  final double? fare;
  final String? pickupLabel;
  final String? dropoffLabel;
  final String? notes;

  static WeeshRideStatus _parseStatus(String s) => switch (s) {
        'accepted' => WeeshRideStatus.accepted,
        'in_progress' => WeeshRideStatus.inProgress,
        'completed' => WeeshRideStatus.completed,
        'cancelled' => WeeshRideStatus.cancelled,
        _ => WeeshRideStatus.pending,
      };

  factory WeeshRide.fromMap(Map<String, dynamic> m) => WeeshRide(
        id: m['id'] as String,
        userId: m['user_id'] as String,
        status: _parseStatus(m['status'] as String? ?? 'pending'),
        requestCode: m['request_code'] as String? ?? '',
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
        driverId: m['driver_id'] as String?,
        fare: m['fare'] != null ? (m['fare'] as num).toDouble() : null,
        pickupLabel: m['pickup_label'] as String?,
        dropoffLabel: m['dropoff_label'] as String?,
        notes: m['notes'] as String?,
      );
}

/// Stream provider that listens to the current user's active ride in real-time.
/// "Active" = status is pending, accepted, or in_progress.
final activeRideStreamProvider = StreamProvider.autoDispose<WeeshRide?>((ref) {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return Stream.value(null);

  return Supabase.instance.client
      .from('weeshes')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .map((rows) {
        final activeStatuses = {'pending', 'accepted', 'in_progress'};
        final activeRows = rows.where((r) => activeStatuses.contains(r['status'])).toList();
        activeRows.sort((a, b) {
          final t1 = DateTime.tryParse(a['created_at'] as String? ?? '') ?? DateTime.now();
          final t2 = DateTime.tryParse(b['created_at'] as String? ?? '') ?? DateTime.now();
          return t2.compareTo(t1); // newest first
        });
        return activeRows.isEmpty ? null : WeeshRide.fromMap(activeRows.first);
      });
});

/// Fetches the assigned driver's details for the active ride.
final assignedDriverProvider = FutureProvider.autoDispose<Driver?>((ref) async {
  final ride = ref.watch(activeRideStreamProvider).value;
  if (ride?.driverId == null) return null;

  final data = await Supabase.instance.client
      .from('drivers')
      .select('id, plate_number, vehicle_type, rating_avg, last_seen_at')
      .eq('id', ride!.driverId!)
      .maybeSingle();

  if (data == null) return null;

  // Join with users table for name
  final userData = await Supabase.instance.client
      .from('users')
      .select('full_name, avatar_url')
      .eq('id', ride.driverId!)
      .maybeSingle();

  return Driver(
    id: ride.driverId!,
    name: userData?['full_name'] as String? ?? 'Your Driver',
    rating: (data['rating_avg'] as num?)?.toDouble() ?? 4.5,
    vehicleType: data['vehicle_type'] as String? ?? 'motorcycle',
    photoUrl: userData?['avatar_url'] as String?,
    plateNumber: data['plate_number'] as String?,
  );
});
