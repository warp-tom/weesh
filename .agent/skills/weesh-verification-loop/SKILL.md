---
name: weesh-verification-loop
description: >
  Quality gate checklist before any feature is considered done in Weesh.
  Run this before every PR or milestone. Covers analyze, test, hot reload,
  Riverpod deps, Android build, and manual smoke test.
triggers:
  - "done"
  - "ready for review"
  - "verification"
  - "quality gate"
  - "before merge"
  - "pre-PR"
  - "checklist"
---

# Weesh Verification Loop Skill

Run every step in order. Do NOT skip steps. A feature is not done until
all 6 steps pass.

---

## Step 1 — Static Analysis

```bash
cd weesh_mobile
flutter analyze
dart run custom_lint
```

**Pass criterion:** Zero issues (warnings AND errors) from both standard analyzer and Weesh custom lints.

Current baseline: `flutter_analyze_output.txt` shows ~20 issues.
Fix all of them before adding new features.

Common fixes:
- Unused imports: remove them
- Prefer `const` constructors: add `const`
- Missing `await`: add `unawaited()` or `await` as appropriate
- `use_build_context_synchronously`: add `if (!mounted) return;` after every `await`

---

## Step 2 — All Tests Pass

```bash
flutter test --coverage
```

*For UI Component changes, verify or update baselines:*
```bash
flutter test --update-goldens
```

**Pass criterion:**
- Zero test failures
- All baseline visual regression (golden) tests pass contextually for multiple screen sizes
- Coverage ≥ 60% for any touched files (run `genhtml` on lcov output to verify)

If any visual test fails, confirm the layout change was intended before updating the master goldens. If any standard test fails, fix the code (not the test) unless the test is provably wrong.

---

## Step 3 — Hot Reload Sanity

If the app is running (`flutter run` is active):

1. Make the code change
2. Press `r` in the terminal to hot reload
3. Navigate to the affected screen
4. Verify no runtime exceptions in the terminal

If you see `FlutterError` or `setState called after dispose`, fix before proceeding.

---

## Step 4 — Riverpod Provider Graph Check

Look for these patterns (they indicate architectural problems):

```bash
# Check for circular provider references
grep -rn "ref.read(.*Provider)" lib/features/ --include="*.dart" | grep -v "notifier\|_test"
```

Manual check:
- No provider watches another provider that watches it back
- `keepAlive: true` providers don't watch auto-disposed providers
- Controllers dispose of stream subscriptions in `ref.onDispose()`

---

## Step 5 — Debug Build Succeeds

```bash
flutter build apk --debug
```

**Pass criterion:** Build exits with code 0, APK produced.

If Android Gradle fails (known issue from `pub_get_error.txt`):
1. Check Gradle wrapper version compatibility
2. Run `flutter clean && flutter pub get` first

---

## Step 6 — Manual Smoke Test

Run through this exact flow on a device or emulator:

| Step | Action | Expected |
|---|---|---|
| 1 | Cold start app | Splash → auth redirect |
| 2 | Sign in with Google | Dashboard appears |
| 3 | Tap Ride | Ride booking screen loads, map visible |
| 4 | Tap Parcel | Parcel flow loads |
| 5 | View Activity | Activity screen loads (may show empty state) |
| 6 | View Profile | Profile screen with role toggle visible |
| 7 | Toggle Driver mode | UI reflects change |
| 8 | Sign out | Returns to onboarding |

**Pass criterion:** No crashes, no red error banners, all screens load.

---

## Pre-Commit Security Check

Before pushing:
```bash
# No hardcoded credentials
grep -rn "supabase\.co\|eyJ" weesh_mobile/lib/ --include="*.dart"
# Expected: 0 results
```

---

## Exit Gate Summary

| Check | Command | Pass Condition |
|---|---|---|
| Analyze | `flutter analyze` & `dart run custom_lint` | 0 issues across both checks |
| Tests & UI Regression | `flutter test` & `--update-goldens` | 0 failures, visual layouts matched precisely |
| Hot reload | manual | No runtime errors |
| Provider graph | manual | No circular deps |
| Build | `flutter build apk --debug` | Exit 0 |
| Smoke test | manual on device | All 8 steps pass |
