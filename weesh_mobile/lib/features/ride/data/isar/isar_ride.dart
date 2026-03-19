import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';

part 'isar_ride.g.dart';

@collection
class IsarRide {
  Id id = Isar.autoIncrement;

  @Index()
  late String remoteId; // Supabase UUID

  @Index()
  late String userId;

  late double pickupLat;
  late double pickupLng;
  late double dropLat;
  late double dropLng;

  @Enumerated(EnumType.name)
  late SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
}
