import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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
    if(initScheduled){
      final locationName= await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return _notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }

  /// Scheduled notification need TimeZone or Native Time Zone plugin and you need to initialize in main
  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    //scheduledDate mandatory
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate,tz.local),
      await notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    /// if we want to send notification daily bases wee need to put "matchDateTimeComponents: DateTimeComponents.time" in zonedSchedule method
    /// and put a method
  }

  /// if we want to send notification daily bases wee need to put "matchDateTimeComponents: DateTimeComponents.time" in zonedSchedule method
  static Future showScheduledNotificationDailyBases(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    //scheduledDate mandatory
    return _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly( Time(00,38),days:[DateTime.monday,DateTime.friday]),///if you want specific day for notification
        ///you can add "days:[DateTime.monday,DateTime.tuesday]"

        /// We set notification at 8 am every morning
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    /// and put a method
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now) /// We check that whether before
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
  static tz.TZDateTime _scheduleWeekly(Time time,{required List<int>days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);
    while(days.contains(scheduledDate.weekday)){
      scheduledDate=scheduledDate.add(const Duration(days:1));
    }
    return scheduledDate;
  }
}

/// NotificationApi.showScheduledNotificationDailyBases(scheduledDate: scheduledDate); metodu init state icerisinde cagırısak kendiliginden yarlanmıs olur
