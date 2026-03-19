import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';

part 'isar_driver_state.g.dart';

@collection
class IsarDriverState {
  Id id = Isar.autoIncrement;

  @Index()
  late String remoteId; // driver uuid

  @Index()
  late String driverId;

  late bool isOnline;
  late double currentLat;
  late double currentLng;

  @Enumerated(EnumType.name)
  late SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
}
