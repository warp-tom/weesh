---
name: weesh-tdd-dart
description: >
  Test-driven development patterns for the Weesh Flutter app. Use when
  adding a new feature, fixing a bug, or writing repositories and
  controllers. Covers unit tests, widget tests, and Riverpod test patterns.
triggers:
  - "test"
  - "unit test"
  - "widget test"
  - "TDD"
  - "coverage"
  - "mock"
  - "fake repository"
---

# Weesh TDD + Dart Testing Skill

## Current Situation

Only one smoke test exists (`test/widget_test.dart`). The target is 60%+
coverage as a starting floor before expanding. Prioritize testing:
1. Repository layer (most critical — offline logic)
2. Riverpod controllers / notifiers
3. Critical screen widgets (auth flow + ride booking)

## Run Tests

```bash
cd weesh_mobile
flutter test                              # all tests
flutter test test/features/weesh_ride/   # single feature
flutter test --coverage                  # with lcov
```

## File Structure

Mirror the `lib/` structure under `test/`:

```
test/
├── features/
│   ├── weesh_ride/
│   │   ├── domain/
│   │   │   └── ride_request_test.dart
│   │   ├── data/
│   │   │   └── isar_ride_repository_test.dart
│   │   ├── application/
│   │   │   └── ride_controller_test.dart
│   │   └── presentation/
│   │       └── ride_booking_screen_test.dart
│   └── auth/
│       └── application/
│           └── auth_controller_test.dart
├── core/
│   └── database/
│       └── isar_service_test.dart
└── widget_test.dart                      # keep existing smoke test
```

## Unit Test: Domain Model

```dart
// test/features/weesh_ride/domain/ride_request_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:weesh_mobile/features/weesh_ride/domain/models/ride_request.dart';

void main() {
  group('RideRequest', () {
    test('copyWith updates syncStatus', () {
      const original = RideRequest(
        id: '1', userId: 'u1',
        pickupLatLng: LatLng(lat: 14.5, lng: 121.0),
        dropLatLng: LatLng(lat: 14.6, lng: 121.1),
      );
      final updated = original.copyWith(syncStatus: SyncStatus.synced);
      expect(updated.syncStatus, SyncStatus.synced);
      expect(updated.id, original.id); // unchanged
    });
  });
}
```

## Unit Test: Fake Repository Pattern

Create fake implementations in `test/fakes/`:

```dart
// test/fakes/fake_ride_repository.dart
class FakeRideRepository implements RideRepository {
  final List<RideRequest> _rides = [];

  @override
  Future<RideRequest> createRide(RideRequest request) async {
    _rides.add(request.copyWith(syncStatus: SyncStatus.pending));
    return _rides.last;
  }

  @override
  Stream<List<RideRequest>> watchActiveRides(String userId) =>
      Stream.value(_rides.where((r) => r.userId == userId).toList());

  @override
  Future<void> syncPending() async {}
}
```

## Riverpod Controller Test

Use `ProviderContainer` with `overrideWith`:

```dart
// test/features/weesh_ride/application/ride_controller_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_ride_repository.dart';

void main() {
  late ProviderContainer container;
  late FakeRideRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeRideRepository();
    container = ProviderContainer(
      overrides: [
        rideRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);
  });

  test('requestRide sets state to synced', () async {
    final notifier = container.read(rideControllerProvider.notifier);
    await notifier.request(testRideRequest);

    final state = container.read(rideControllerProvider);
    expect(state.hasValue, true);
    expect(state.value?.syncStatus, SyncStatus.pending); // local write
  });
}
```

## Widget Test with ProviderScope

```dart
// test/features/weesh_ride/presentation/ride_booking_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RideBookingScreen shows idle state on load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          rideRepositoryProvider.overrideWithValue(FakeRideRepository()),
        ],
        child: const MaterialApp(home: RideBookingScreen()),
      ),
    );

    expect(find.text('Where to?'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
```

## Coverage Targets

| Layer | Target |
|---|---|
| Domain models | 90% |
| Repository implementations | 80% |
| Riverpod controllers | 75% |
| Screen widgets | 50% (smoke only for complex screens) |

## TDD Workflow

1. Write a failing test that describes the desired behavior
2. Implement the minimum code to make it pass
3. Refactor (no new logic, just clean up)
4. Run `flutter analyze` to confirm no regressions

## Checklist

- [ ] Test file mirrors `lib/` path under `test/`
- [ ] Fakes in `test/fakes/` (not mocks—fakes are simpler and more readable)
- [ ] `ProviderContainer` used for controller tests
- [ ] `ProviderScope` with overrides used for widget tests
- [ ] `addTearDown(container.dispose)` in setUp
- [ ] `flutter test --coverage` run and coverage ≥ 60% for touched code
