---
name: weesh-flutter-architecture
description: >
  Enforces the feature-first DDD architecture for the Weesh Flutter app.
  Use PROACTIVELY whenever adding a new screen, feature module, or business
  logic to weesh_mobile/lib/. Prevents logic leaking into widget trees.
triggers:
  - "new screen"
  - "new feature"
  - "add provider"
  - "add repository"
  - "add service"
  - "add controller"
---

# Weesh Flutter Architecture Skill

## Project-Specific Context

- **App:** `weesh_mobile` (Flutter 3.41, Dart 3.11+, Impeller engine)
- **State:** Riverpod 2.5+ with `riverpod_generator` + `riverpod_annotation`
- **Router:** `go_router ^17` (shell routes + full-screen immersive flows)
- **Local DB:** Isar `^3.1.0` (offline-first)
- **Backend:** Supabase Flutter `^2.12.0`
- **Maps:** Mapbox Maps Flutter `^2.19.1`

## Feature Directory Layout

Every feature under `lib/features/<feature_name>/` MUST follow this structure:

```
features/weesh_ride/
├── domain/
│   ├── models/          # Pure Dart data classes (no Flutter imports)
│   │   └── ride_request.dart
│   └── repositories/    # Abstract interfaces only
│       └── ride_repository.dart
├── data/
│   ├── isar/            # Isar @collection schemas
│   │   └── isar_ride.dart
│   └── repositories/    # Concrete implementations
│       └── isar_ride_repository.dart
├── application/
│   └── ride_controller.dart   # AsyncNotifier / Notifier (Riverpod)
└── presentation/
    ├── screens/
    │   └── ride_booking_screen.dart
    └── widgets/         # Sub-widgets extracted from screens
        └── chariot_selector.dart
```

Existing features that need migration: `weesh_ride`, `weesh_parcel`, `weesh_grocery`, `driver_active`.
`auth` and `profile` are partially layered — complete them first as the template.

## The Golden Rule

> **Widgets display state. Controllers/Notifiers change state. Repositories own data.**

Never call `supabase.from(...)` or `Isar.getInstance()` directly inside a widget or screen.
Always route through a provider-exposed controller or repository.

## Layer Responsibilities

### `domain/models/`
- Pure Dart classes only (`@immutable`, no Flutter SDK imports)
- Use `const` constructors
- Include `copyWith` and `==` / `hashCode` (use `freezed` or manual)
- Example:
  ```dart
  @immutable
  class RideRequest {
    const RideRequest({
      required this.id,
      required this.userId,
      required this.pickupLatLng,
      required this.dropLatLng,
      this.syncStatus = SyncStatus.pending,
    });
    final String id;
    final String userId;
    final LatLng pickupLatLng;
    final LatLng dropLatLng;
    final SyncStatus syncStatus;
  }
  enum SyncStatus { pending, synced, failed }
  ```

### `domain/repositories/` (interfaces)
- Abstract class with `Future<>` or `Stream<>` return types only
- No implementation details, no Isar/Supabase types exposed
  ```dart
  abstract class RideRepository {
    Future<RideRequest> createRide(RideRequest request);
    Stream<List<RideRequest>> watchActiveRides(String userId);
    Future<void> syncPending();
  }
  ```

### `data/repositories/` (implementations)
- Implement the domain interface
- Write to Isar first, enqueue Supabase sync
- Never throw raw Supabase/Isar exceptions — wrap in domain exceptions

### `application/` (Riverpod controllers)
- Use `AsyncNotifier<T>` for async mutable state
- Expose only domain models to the presentation layer
- Handle errors by returning `AsyncError` state (never `showDialog` from here)
  ```dart
  @riverpod
  class RideController extends _$RideController {
    @override
    FutureOr<RideRequest?> build() => null;

    Future<void> requestRide(RideRequest req) async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(
        () => ref.read(rideRepositoryProvider).createRide(req),
      );
    }
  }
  ```

### `presentation/screens/`
- Only call `ref.watch()` and `ref.read()` on providers
- All UI state driven by `AsyncValue.when()`
- Keep screen files ≤ 300 lines; extract to `widgets/` when exceeded
- Do NOT use `BuildContext` extensions from `velocity_x` for business actions

## go_router Conventions

Shell routes are in `lib/core/router/`. Follow this classification strictly:

| Route tier | Pattern | Example |
|---|---|---|
| Unauthenticated | `/onboarding`, `/login` | Auth flows |
| Authenticated shell | `/home`, `/activity`, `/profile` | Tab bar nav |
| Immersive full-screen | `/ride/booking`, `/parcel/active` | No bottom bar |

- **Redirect guards** live in `core/router/` using `ref.read(authControllerProvider)`
- Never use `Navigator.push` for cross-feature navigation; always use `context.go()` or `context.push()`

## Code Generation

After modifying any `@riverpod` annotated file or Isar `@Collection` schema, run:

```bash
cd weesh_mobile
flutter pub run build_runner build --delete-conflicting-outputs
```

## Checklist Before Marking a Feature Done

- [ ] Domain model is pure Dart (no Flutter/Isar/Supabase imports)
- [ ] Repository interface is defined in `domain/repositories/`
- [ ] Implementation writes to Isar before Supabase
- [ ] Controller exposes `AsyncValue<T>` to the UI
- [ ] Screen uses `.when(data:, loading:, error:)` pattern
- [ ] No direct Supabase/Isar calls in any widget file
- [ ] `flutter analyze` returns 0 issues for the feature directory
