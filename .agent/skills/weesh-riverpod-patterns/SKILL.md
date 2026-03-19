---
name: weesh-riverpod-patterns
description: >
  Riverpod 2.5+ patterns for the Weesh app. Use when adding providers,
  controllers, or wiring state to UI. Enforces consistent generator syntax,
  provider scoping, and AsyncValue handling across weesh_mobile.
triggers:
  - "add provider"
  - "state management"
  - "riverpod"
  - "AsyncNotifier"
  - "StreamProvider"
  - "FutureProvider"
---

# Weesh Riverpod Patterns Skill

## Package Versions (from pubspec.yaml)

```yaml
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.6.1
riverpod_generator: ^2.4.0     # dev
build_runner: ^2.4.13          # dev
```

Always run `build_runner` after changing annotated files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Provider Type Selection Guide

| Need | Provider Type | Example |
|---|---|---|
| Read-only async value (one-shot) | `@riverpod Future<T>` | fetch user profile |
| Read-only real-time stream | `@riverpod Stream<T>` | Supabase realtime channel |
| Mutable async state (no params) | `AsyncNotifier<T>` | ride booking state |
| Mutable sync state | `Notifier<T>` | UI toggle, role switch |
| Scoped to a family key | `@riverpod` with params | provider per ride ID |

## Annotation Conventions

### Simple async fetch (auto-disposed by default)
```dart
// lib/features/auth/application/auth_provider.dart
part 'auth_provider.g.dart';

@riverpod
Future<WeeshUser?> currentUser(Ref ref) async {
  final session = supabase.auth.currentSession;
  if (session == null) return null;
  return ref.read(userRepositoryProvider).getUser(session.user.id);
}
```

### Always-alive provider (use sparingly — only for app-lifetime singletons)
```dart
@Riverpod(keepAlive: true)
IsarService isarService(Ref ref) => IsarService();
```

### Mutable controller with AsyncNotifier
```dart
// lib/features/weesh_ride/application/ride_controller.dart
part 'ride_controller.g.dart';

@riverpod
class RideController extends _$RideController {
  @override
  FutureOr<RideRequest?> build() => null; // null = idle state

  Future<void> request(RideRequest req) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(rideRepositoryProvider).createRide(req),
    );
  }

  void reset() => state = const AsyncData(null);
}
```

### Supabase Realtime → Stream provider
```dart
@riverpod
Stream<List<ActiveTrip>> activeTrips(Ref ref, String userId) {
  return ref.read(supabaseProvider)
      .from('active_trips')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((rows) => rows.map(ActiveTrip.fromJson).toList());
}
```

## Consuming Providers in Widgets

### Full AsyncValue handling (required pattern)
```dart
class RideStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideControllerProvider);
    return state.when(
      data: (ride) => ride == null ? const IdleRideCard() : ActiveRideCard(ride: ride),
      loading: () => const WeeshLoadingIndicator(),
      error: (e, _) => ErrorBanner(message: e.toString()),
    );
  }
}
```

### One-off read for actions (in callbacks only)
```dart
onPressed: () => ref.read(rideControllerProvider.notifier).request(req),
```

**Never** use `ref.read()` in `build()`. Always `ref.watch()` in build.

## Provider Scoping Rules

- Providers live in `lib/features/<feature>/application/` or `lib/core/`
- Repository providers live in `lib/features/<feature>/data/`
- Infrastructure providers (Isar, Supabase client) live in `lib/core/`
- Cross-feature providers should be rare — route through a shared domain model

## Common Core Providers to Define

```dart
// lib/core/providers/supabase_provider.dart
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) => Supabase.instance.client;

// lib/core/providers/isar_provider.dart
@Riverpod(keepAlive: true)
Future<Isar> isar(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([IsarRideSchema, IsarParcelSchema], directory: dir.path);
}
```

## Error Handling Conventions

- Never `showDialog` or `ScaffoldMessenger.of(context)` from inside a provider
- Return `AsyncError` and let the widget layer decide how to display it
- Log unexpected errors with a tag: `debugPrint('[RideController] ERROR: $e')`
- Define typed domain exceptions in `lib/core/exceptions/`:
  ```dart
  class WeeshNetworkException implements Exception {
    const WeeshNetworkException(this.message);
    final String message;
  }
  ```

## Lint & Analysis

Install `riverpod_lint` to catch ref misuse:
```yaml
# pubspec.yaml dev_dependencies
riverpod_lint: ^2.0.0
custom_lint: ^0.6.0
```

Run: `flutter pub run custom_lint`
