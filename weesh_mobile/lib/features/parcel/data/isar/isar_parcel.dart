import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';

part 'isar_parcel.g.dart';

@collection
class IsarParcel {
  Id id = Isar.autoIncrement;

  @Index()
  late String remoteId; // Supabase UUID

  @Index()
  late String userId;

  late double pickupLat;
  late double pickupLng;
  late double dropLat;
  late double dropLng;

  late String receiverName;
  late String receiverPhone;
  late String parcelDescription;

  @Enumerated(EnumType.name)
  late SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
}
