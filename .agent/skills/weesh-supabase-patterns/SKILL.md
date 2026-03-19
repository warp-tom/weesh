---
name: weesh-supabase-patterns
description: >
  Safe Supabase Flutter patterns for the Weesh app. Use whenever writing
  auth, database, realtime, or storage calls. Prevents direct SDK use in
  widgets and enforces secure config handling.
triggers:
  - "supabase"
  - "auth"
  - "sign in"
  - "sign up"
  - "google sign in"
  - "database query"
  - "realtime"
  - "RLS"
  - "environment config"
---

# Weesh Supabase Patterns Skill

## Package Versions (from pubspec.yaml)

```yaml
supabase_flutter: ^2.12.0
google_sign_in: ^7.2.0
```

## 🚨 Critical: Config Must Never Be Hardcoded

The project audit flagged hardcoded `supabaseUrl` and `supabaseAnonKey` in
the bootstrap. Fix this immediately.

### Correct pattern — `--dart-define` based:

```dart
// lib/main.dart
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
);
```

Run locally with:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Store a `.env.local` (gitignored) with these values for convenience.
Never commit actual keys to the repository.

## Provider Setup (core)

```dart
// lib/core/providers/supabase_provider.dart
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) => Supabase.instance.client;
```

## Auth Controller Pattern

Never call `supabase.auth.*` directly from a widget. Route through this controller:

```dart
// lib/features/auth/application/auth_controller.dart
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() {
    // Listen for auth state changes
    ref.listen(authStateProvider, (_, next) {
      state = AsyncData(next.session?.user);
    });
    return Supabase.instance.client.auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw const WeeshAuthCancelledException();
      final auth = await googleUser.authentication;
      await ref.read(supabaseProvider).auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: auth.idToken!,
        accessToken: auth.accessToken,
      );
      return ref.read(supabaseProvider).auth.currentUser;
    });
  }

  Future<void> signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
    state = const AsyncData(null);
  }
}
```

## Auth State Stream Provider

```dart
@riverpod
Stream<AuthState> authState(Ref ref) =>
    ref.read(supabaseProvider).auth.onAuthStateChange;
```

## Database Query Patterns

### One-shot query (use `@riverpod Future<T>`)
```dart
@riverpod
Future<List<WeeshDriver>> nearbyDrivers(Ref ref, LatLng location) async {
  final result = await ref.read(supabaseProvider)
      .rpc('nearby_drivers', params: {
        'lat': location.lat,
        'lng': location.lng,
        'radius_km': 5,
      });
  return (result as List).map(WeeshDriver.fromJson).toList();
}
```

### Realtime stream (use `@riverpod Stream<T>`)
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

## RLS Policy Assumptions

Every Supabase table the app reads/writes MUST have:
- `auth.uid() = user_id` policy for user-owned rows
- RLS enabled (verify via Supabase dashboard Security > RLS)

Never assume a table without RLS is acceptable—even in development.

Tables that need RLS review:
- `rides`
- `parcels`
- `grocery_orders`
- `drivers`
- `active_trips`

## Error Normalization

Wrap Supabase errors before exposing to the domain layer:

```dart
// lib/core/exceptions/weesh_exceptions.dart
class WeeshNetworkException implements Exception {
  const WeeshNetworkException(this.message);
  final String message;
}

class WeeshAuthException implements Exception {
  const WeeshAuthException(this.message);
  final String message;
}

class WeeshAuthCancelledException implements Exception {
  const WeeshAuthCancelledException();
}
```

In repositories:
```dart
try {
  await supabase.from('rides').insert(data);
} on PostgrestException catch (e) {
  throw WeeshNetworkException(e.message);
} on AuthException catch (e) {
  throw WeeshAuthException(e.message);
}
```

## WhatsApp / Facebook Auth Fallback

For low-signal areas where SMS OTP fails:
```dart
Future<void> signInWithWhatsApp() async {
  await ref.read(supabaseProvider).auth.signInWithOtp(
    phone: phoneNumber,
    channel: OtpChannel.whatsapp,
  );
}
```

## Storage (Proof of Delivery Photos)

```dart
Future<String> uploadDeliveryPhoto(File photo, String parcelId) async {
  final path = 'delivery/$parcelId/${DateTime.now().millisecondsSinceEpoch}.jpg';
  await ref.read(supabaseProvider).storage
      .from('delivery-photos')
      .upload(path, photo);
  return ref.read(supabaseProvider).storage
      .from('delivery-photos')
      .getPublicUrl(path);
}
```

Storage bucket `delivery-photos` must have:
- RLS: only authenticated users can upload to their own `delivery/<parcelId>` path
- No public read without signed URLs

## Checklist

- [ ] No supabaseUrl or supabaseAnonKey in committed code
- [ ] `supabase` client accessed via `ref.read(supabaseProvider)` only
- [ ] Auth calls go through `AuthController`, not directly from widgets
- [ ] RLS enabled on all tables used by the app
- [ ] Supabase exceptions wrapped in domain exceptions at repository boundary
