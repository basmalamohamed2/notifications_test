import 'dart:async';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();

  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  // Scheduled Notification
  static void showSchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'schduled notification',
      'id 1',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = NotificationDetails(android: android);

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    tz.TZDateTime scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    // in future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate =
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'body',
      scheduledDate,
      details,
      payload: 'zonedSchedule',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Daily Scheduled Notification
  static void showDailySchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily schduled notification',
      'id 2',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    var currentTime = tz.TZDateTime.now(tz.local);

    log("Current Time: ${currentTime.toString()}");

    var scheduleTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      7,
    );

    log("Scheduled Time Before Adjustment: ${scheduleTime.toString()}");

    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(hours: 1));
      log("Scheduled Time After Adjustment: ${scheduleTime.toString()}");
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      'Daily Schduled Notification',
      'body',
      scheduleTime,
      details,
      payload: 'zonedSchedule',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
