---
name: weesh-security-review
description: >
  Security checklist specific to the Weesh app's risk surface. Use before
  every PR merge and whenever touching auth, Supabase, file upload, or
  device permissions. Prevents credential leaks, RLS bypasses, and PII risks.
triggers:
  - "security"
  - "secrets"
  - "supabase key"
  - "RLS"
  - "permissions"
  - "PII"
  - "camera"
  - "location"
  - "google sign in"
  - "before merge"
  - "pre-commit"
---

# Weesh Security Review Skill

## STOP — Run This Before Every Merge

## 1. Credential & Config Secrets

- [ ] **No `supabaseUrl` or `supabaseAnonKey` in any committed `.dart` file**
  - Grep check: `grep -r "supabase.co" lib/` must return 0 results in `.dart` files
  - They belong in `--dart-define` values or CI env vars only
- [ ] **No `MAPBOX_` tokens in committed code** — use `--dart-define=MAPBOX_PUBLIC_TOKEN=...`
- [ ] **No Google OAuth client IDs hardcoded** — use `--dart-define` or `google-services.json` (gitignored)
- [ ] `.env*` files are in `.gitignore`
- [ ] `google-services.json` and `GoogleService-Info.plist` are in `.gitignore`

## 2. Supabase RLS

Every table the code reads or writes MUST have Row Level Security.

- [ ] `rides` table: `auth.uid() = user_id`
- [ ] `parcels` table: `auth.uid() = user_id`
- [ ] `active_trips` table: driver row accessible only to driver + assigned user
- [ ] `users` / `profiles` table: `auth.uid() = id`
- [ ] No table with `anon` read/write policy for sensitive data
- [ ] Verify via: Supabase Dashboard → Table Editor → RLS badge

## 3. Authentication

- [ ] `idToken` from Google Sign-In is validated **server-side** (Supabase handles this via `signInWithIdToken`)
- [ ] Supabase session tokens are stored in Flutter Secure Storage (Supabase SDK does this by default — never override)
- [ ] Never log `session.accessToken` or `session.refreshToken` to console
- [ ] Auth state changes handled via `supabase.auth.onAuthStateChange` stream, not polling
- [ ] Unauthenticated routes in go_router always redirect if a session exists

## 4. PII in Isar

Local Isar DB contains user data that persists on-device.

- [ ] Only store **operationally necessary** fields locally (no full profile photos)
- [ ] Delivery/proof photos have a TTL — delete from device after successful sync
- [ ] User phone number/email in Isar: evaluate necessity vs. just caching the user ID
- [ ] On sign-out, clear user-specific Isar collections:
  ```dart
  await isar.writeTxn(() async {
    await isar.isarRides.clear();
    await isar.isarParcels.clear();
  });
  ```

## 5. Camera & Location Permissions

- [ ] Request location permission at the point of use (ride booking), not at app start
- [ ] Request camera permission at the point of use (proof of delivery), not at app start
- [ ] Handle `PermissionStatus.permanentlyDenied` with a friendly settings redirect
- [ ] Android manifest declares only `ACCESS_FINE_LOCATION` (not `BACKGROUND_LOCATION` unless driver mode explicitly needs it)
- [ ] iOS `Info.plist` has `NSLocationWhenInUseUsageDescription` with a Weesh-specific message (not generic)

## 6. Proof-of-Delivery Photo Storage

- [ ] Supabase storage bucket `delivery-photos` has RLS:
  - Authenticated upload: user can upload to `delivery/<their parcel id>/*`
  - No unauthenticated read
- [ ] Photo URL returned to the client is a signed URL with expiry (not public)
- [ ] Local copy of photo deleted after successful upload

## 7. Realtime Channel Security

- [ ] Supabase Realtime channels use `private` presence channels where applicable
- [ ] Never subscribe to `active_trips` channel without filtering by `user_id` or `driver_id`

## 8. Input Validation

- [ ] Phone number inputs validated before sending to Supabase OTP
- [ ] Lat/lng inputs clamped to valid ranges before Mapbox or Supabase calls
- [ ] File size checked before upload (max 5MB for proof-of-delivery photos)

## Grep Commands for Automated Checks

Run these in CI or before any security review:

```bash
# Check for hardcoded Supabase credentials
grep -rn "supabase\.co" weesh_mobile/lib/ --include="*.dart"

# Check for hardcoded API keys patterns
grep -rn "eyJ" weesh_mobile/lib/ --include="*.dart"

# Check for console.log / print of tokens
grep -rn "print.*token\|print.*key\|debugPrint.*token" weesh_mobile/lib/ --include="*.dart"
```

Expected result for all: 0 matches.
