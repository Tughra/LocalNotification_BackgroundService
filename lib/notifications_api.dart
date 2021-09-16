import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  /// first initialize notification package
  static final _notifications = FlutterLocalNotificationsPlugin();
  /// We want to also listen notifications therefore we need to go main page and put the call NotificationApi's init method inside the main init method.
  static final onNotifications = BehaviorSubject<String?>();

  /// In Android our notification is links to a channel therefore we need to create channel
  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            "channelId", "channelName", "channelDescription",
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  /// implementing functionality is ;
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = IOSInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return _notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }
/// Scheduled notification need TimeZone or Native Time Zone plugin and you need to initialize in main
  static Future showScheduledNotification(

      {int id = 0, String? title, String? body, String? payload,required DateTime scheduledDate}) async {
    return _notifications.zonedSchedule(id, title, body,tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),await notificationDetails(),
        payload: payload,androidAllowWhileIdle:true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
