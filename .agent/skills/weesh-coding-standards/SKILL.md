---
name: weesh-coding-standards
description: >
  Universal Dart/Flutter coding standards for the Weesh project. Use
  proactively on every file you edit. Enforces analysis_options.yaml rules,
  import ordering, file sizing, null safety, and build_runner conventions.
triggers:
  - "always"
  - "refactor"
  - "edit file"
  - "new file"
  - "clean up"
  - "lint"
  - "analyze"
---

# Weesh Coding Standards Skill

> Apply these rules on **every** file you create or modify in `weesh_mobile/`.

## Analysis Options

`analysis_options.yaml` is already configured. Never relax a lint rule
without an explicit code comment explaining why and a TODO to remove it.

Run before every commit:
```bash
flutter analyze
```
Zero issues is the only acceptable result. Fix warnings, not just errors.

## Import Ordering

Use this exact ordering (one blank line between groups):

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages (alphabetical within group)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 4. Internal — core (before features)
import 'package:weesh_mobile/core/theme/app_theme.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';

// 5. Internal — features
import 'package:weesh_mobile/features/weesh_ride/domain/models/ride_request.dart';
```

Never use relative imports (`../../../`) for cross-feature or cross-layer references.
Relative imports are only acceptable within the same subdirectory.

## File Size Limits

| File type | Limit | Action when exceeded |
|---|---|---|
| Screen widget | 300 lines | Extract sub-widgets to `widgets/` |
| Controller | 200 lines | Split into multiple controllers |
| Repository | 250 lines | Extract query helpers |
| Domain model | 100 lines | Split into multiple models |

## Null Safety Rules

- Never use `!` (force-unwrap) without a comment:
  ```dart
  // Safe: map guarantees this key exists after the filter call above
  final value = map['key']!;
  ```
- Prefer `?.` and `??` chains over explicit null checks where readable
- Avoid `late` outside of `@collection` Isar schemas — use nullable + init pattern

## Const Constructors

Every stateless leaf widget must use `const`. The analyzer will flag missing ones.

```dart
// ✅ Correct
const WeeshLoadingIndicator();
const SizedBox.shrink();

// ❌ Wrong
WeeshLoadingIndicator();
SizedBox.shrink();
```

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| File | `snake_case.dart` | `ride_booking_screen.dart` |
| Class | `PascalCase` | `RideBookingScreen` |
| Provider | `camelCase` + `Provider` suffix | `rideControllerProvider` |
| Isar schema | `Isar` prefix | `IsarRide` |
| Domain model | No prefix | `RideRequest` |
| Abstract repo | Interface name | `RideRepository` |
| Tests | Mirror src + `_test` suffix | `ride_controller_test.dart` |

## Generated Files

Files ending in `.g.dart` and `.freezed.dart` are generated — never edit them.

After changing any annotated file:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Add to `.gitignore` if not already present:
```
*.g.dart
*.freezed.dart
```
These should be generated at build time, not committed.

## Comments & Documentation

- Public API methods: use `///` doc comments
- Complex logic blocks: use `//` inline comments explaining *why*, not *what*
- TODO format: `// TODO(username): description — GH #issue`
- Never leave commented-out code in committed files

## velocity_x Usage Rule

`velocity_x` provides utility extensions (`.px`, `.text`, `.box`, etc.).
- ✅ Use for layout helpers and text styling
- ❌ Never use `VxNavigator` — use `context.go()` / `context.push()` from go_router
- ❌ Never use `VxState` — use Riverpod providers

## Checklist

- [ ] `flutter analyze` returns 0 issues
- [ ] Imports follow the 5-group order
- [ ] File is under the line limit for its type
- [ ] No force-unwrap `!` without a justifying comment
- [ ] Const constructors on all stateless leaf widgets
- [ ] Generated files not committed
