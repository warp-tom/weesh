# ──────────────────────────────────────────────────────────────────────────────
# Weesh Mobile — ProGuard / R8 Rules
# Applied in both debug (shrink only) and release builds.
# ──────────────────────────────────────────────────────────────────────────────

# ── Flutter Engine ────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ── Isar (uses native reflection) ────────────────────────────────────────────
-keep class dev.isar.** { *; }
-keep class com.isar.** { *; }

# ── Supabase / Realtime ───────────────────────────────────────────────────────
-keep class io.supabase.** { *; }
-keep class com.realtime.** { *; }

# ── MapLibre GL ───────────────────────────────────────────────────────────────
-keep class org.maplibre.** { *; }
-keep class com.maplibre.** { *; }

# ── OkHttp (required for network stack) ──────────────────────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ── Kotlin Stdlib ─────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# ── Gson (MapLibre style parsing) ─────────────────────────────────────────────
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# ── Geolocator ────────────────────────────────────────────────────────────────
-keep class com.baseflow.geolocator.** { *; }

# ── Permission Handler ────────────────────────────────────────────────────────
-keep class com.baseflow.permissionhandler.** { *; }

# ── Image Picker ──────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.imagepicker.** { *; }

# ── Notification ──────────────────────────────────────────────────────────────
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# ── Accessibility Tools ───────────────────────────────────────────────────────
-keep class com.google.android.accessibility.** { *; }

# ── Suppress noisy warnings from emulator-only classes ───────────────────────
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# ── Google Play Core (referenced by Flutter engine but not in debug APKs) ─────
# These classes are optional for Flutter (Play Store delivery only).
# Use -dontwarn only — adding -keep for absent classes causes R8 to fail.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

