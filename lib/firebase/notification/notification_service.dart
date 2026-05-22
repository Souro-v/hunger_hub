import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/storage/local_storage.dart';
import '../firestore/user_service.dart';

// ── Background Message Handler ──
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.showLocalNotification(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ── Android Channel ──
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'hungryhub_channel',
    'HungryHub Notifications',
    description: 'Order updates and offers',
    importance: Importance.high,
  );

  // ── Initialize ──
  Future<void> init() async {
    // ── Request Permission ──
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ── Local Notifications Setup ──
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // ── Create Channel ──
// TODO: Android e uncomment korbe
// await _localNotifications
//     .resolvePlatformSpecificImplementation
//         AndroidFlutterLocalNotificationsPlugin>()
//     ?.createNotificationChannel(_channel);
    // ── Background Handler ──
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ── Foreground Handler ──
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(message);
    });

    // ── Save FCM Token ──
    await _saveFcmToken();

    // ── Token Refresh ──
    _messaging.onTokenRefresh.listen((token) {
      _updateFcmToken(token);
    });
  }

  // ── Show Local Notification ──
  Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['route'],
    );
  }

  // ── Notification Tap ──
  void _onNotificationTap(NotificationResponse response) {
    // TODO: GoRouter navigate
    // final route = response.payload;
    // if (route != null) router.go(route);
  }

  // ── Save FCM Token ──
  Future<void> _saveFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      await _updateFcmToken(token);
    } catch (e) {
      // ignore
    }
  }

  // ── Update FCM Token ──
  Future<void> _updateFcmToken(String token) async {
    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId == null) return;
      await UserService().saveFcmToken(
        userId: userId,
        token: token,
      );
    } catch (e) {
      // ignore
    }
  }

  // ── Get Token ──
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
