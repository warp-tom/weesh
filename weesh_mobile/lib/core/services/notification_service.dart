import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/core/router/router.dart';

// ---------------------------------------------------------------------------
// Plugin singleton – created once, re-used everywhere
// ---------------------------------------------------------------------------
final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

// ---------------------------------------------------------------------------
// Riverpod provider – exposes the initialised service
// ---------------------------------------------------------------------------
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService._(_plugin);
});

// ---------------------------------------------------------------------------
// NotificationService
// ---------------------------------------------------------------------------
class NotificationService {
  NotificationService._(this._notifications);

  final FlutterLocalNotificationsPlugin _notifications;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialise – call once from main.dart BEFORE runApp
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request Android 13+ notification permission at runtime
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload == 'ride_update') {
      goRouter.push('/active_ride');
    } else if (response.payload == 'parcel_update') {
      goRouter.push('/parcel_tracking');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Notification channels
  // ─────────────────────────────────────────────────────────────────────────
  static const _rideChannel = AndroidNotificationChannel(
    'weesh_rides',
    'Ride Updates',
    description: 'Status updates for your Weesh rides',
    importance: Importance.high,
  );

  static const _parcelChannel = AndroidNotificationChannel(
    'weesh_parcels',
    'Parcel Updates',
    description: 'Status updates for Weesh parcel deliveries',
    importance: Importance.high,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Public notification helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Show a ride-status update notification.
  Future<void> showRideUpdate({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _ensureChannel(_rideChannel);
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _rideChannel.id,
          _rideChannel.name,
          channelDescription: _rideChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload,
    );
  }

  /// Show a parcel-delivery update notification.
  Future<void> showParcelUpdate({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _ensureChannel(_parcelChannel);
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _parcelChannel.id,
          _parcelChannel.name,
          channelDescription: _parcelChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload,
    );
  }

  /// Dismiss a specific notification by id.
  Future<void> dismiss(int id) => _notifications.cancel(id);

  /// Dismiss all notifications.
  Future<void> dismissAll() => _notifications.cancelAll();

  // Creates the Android notification channel if it doesn't exist yet.
  Future<void> _ensureChannel(AndroidNotificationChannel channel) async {
    final androidImpl =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(channel);
  }
}
