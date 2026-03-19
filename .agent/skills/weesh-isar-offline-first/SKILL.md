---
name: weesh-isar-offline-first
description: >
  Offline-first persistence patterns for Weesh using Isar 3.1.0. The core
  product differentiator for Philippine province use. Use whenever creating
  or modifying any data entity that must survive network loss.
triggers:
  - "isar"
  - "offline"
  - "local database"
  - "sync"
  - "cache"
  - "persistence"
  - "new entity"
---

# Weesh Isar Offline-First Skill

## Context

Provincial internet drops frequently. Weesh's core promise is that **active
service state survives network interruptions**. Isar is the local-first
persistence layer. Every transactional entity (rides, parcels, grocery orders)
MUST go through Isar before touching Supabase.

## Package Setup (from pubspec.yaml)

```yaml
isar: ^3.1.0+1
isar_flutter_libs: ^3.1.0+1
path_provider: ^2.1.5
isar_generator: any     # dev
```

Code-gen command after changing schemas:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Schema Design Rules

### Naming Convention
- Isar collection file: `data/isar/isar_<entity>.dart`
- Class name: `Isar<Entity>` (distinguishes from domain model)
- Always include `id`, `syncStatus`, `createdAt`, `updatedAt`

### Sync Status Enum (universal)
```dart
// lib/core/database/isar/sync_status.dart
enum SyncStatus { pending, synced, failed }
```

### Example: Ride Request Schema
```dart
// lib/features/weesh_ride/data/isar/isar_ride.dart
import 'package:isar/isar.dart';

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
  late SyncStatus syncStatus;

  late DateTime createdAt;
  late DateTime updatedAt;
}
```

## The Local-Write-Then-Sync Pattern

This is the canonical flow for all transactional writes:

```dart
// lib/features/weesh_ride/data/repositories/isar_ride_repository.dart

class IsarRideRepository implements RideRepository {
  IsarRideRepository(this._isar, this._supabase);
  final Isar _isar;
  final SupabaseClient _supabase;

  @override
  Future<RideRequest> createRide(RideRequest request) async {
    // 1. ALWAYS write locally first — instant return, no network wait
    final isarRide = IsarRide()
      ..remoteId = request.id
      ..userId = request.userId
      ..pickupLat = request.pickupLatLng.lat
      ..pickupLng = request.pickupLatLng.lng
      ..dropLat = request.dropLatLng.lat
      ..dropLng = request.dropLatLng.lng
      ..syncStatus = SyncStatus.pending
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() => _isar.isarRides.put(isarRide));

    // 2. Attempt cloud sync (fire-and-forget — don't await in the UI path)
    unawaited(_syncToSupabase(isarRide));

    return request.copyWith(syncStatus: SyncStatus.pending);
  }

  Future<void> _syncToSupabase(IsarRide ride) async {
    try {
      await _supabase.from('rides').upsert({
        'id': ride.remoteId,
        'user_id': ride.userId,
        'pickup_lat': ride.pickupLat,
        'pickup_lng': ride.pickupLng,
        'drop_lat': ride.dropLat,
        'drop_lng': ride.dropLng,
        'created_at': ride.createdAt.toIso8601String(),
      });
      await _isar.writeTxn(() async {
        ride.syncStatus = SyncStatus.synced;
        ride.updatedAt = DateTime.now();
        await _isar.isarRides.put(ride);
      });
    } catch (e) {
      await _isar.writeTxn(() async {
        ride.syncStatus = SyncStatus.failed;
        await _isar.isarRides.put(ride);
      });
      // Don't rethrow — the local record is valid even if sync failed
    }
  }
}
```

## Retry Queue for Failed Syncs

Run this on app foreground resume and on connectivity restore:

```dart
Future<void> syncPending() async {
  final failed = await _isar.isarRides
      .filter()
      .syncStatusEqualTo(SyncStatus.pending)
      .or()
      .syncStatusEqualTo(SyncStatus.failed)
      .findAll();

  for (final ride in failed) {
    await _syncToSupabase(ride);
    // Exponential backoff: add retry count field if needed
  }
}
```

## Watching Local State (Streams)

Prefer Isar `watchLazy` for Riverpod `Stream` providers:

```dart
@riverpod
Stream<List<RideRequest>> userRides(Ref ref, String userId) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.isarRides
      .filter()
      .userIdEqualTo(userId)
      .watch(fireImmediately: true)
      .map((list) => list.map(_toRideRequest).toList());
}
```

## Isar Initialization (core provider)

```dart
// lib/core/database/isar_service.dart
@Riverpod(keepAlive: true)
Future<Isar> isar(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [IsarRideSchema, IsarParcelSchema, IsarUserSchema],
    directory: dir.path,
    name: 'weesh_db',
  );
}
```

## Source of Truth Rules

| Scenario | Source of truth |
|---|---|
| Active trip in progress | Isar (local) |
| Trip history / receipts | Supabase (remote, after sync) |
| Driver availability | Supabase (realtime) |
| User profile | Supabase (auth session) |
| Pending/unsent requests | Isar (syncStatus = pending) |

## Entities That Need Isar Schemas

- [ ] `IsarRide` (ride requests)
- [ ] `IsarParcel` (parcel deliveries)
- [ ] `IsarGroceryOrder` (grocery orders)
- [ ] `IsarDriverState` (driver online/offline/active)

## Checklist

- [ ] Schema has `syncStatus` field with `SyncStatus` enum
- [ ] Write to Isar before any Supabase call
- [ ] Sync is fire-and-forget (not awaited in UI path)
- [ ] `syncPending()` called on app resume / connectivity restore
- [ ] `watchLazy` used for Riverpod stream providers
- [ ] Schema regenerated with `build_runner` after changes
