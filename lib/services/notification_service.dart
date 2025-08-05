import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isGranted) {
      return true;
    }
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true;
    }
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }

  static Future<bool> requestAllPermissions() async {
    final notificationGranted = await requestNotificationPermission();
    final exactAlarmGranted = await requestExactAlarmPermission();
    return notificationGranted && exactAlarmGranted;
  }

  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final permissionsGranted = await requestAllPermissions();
    if (!permissionsGranted) {
      debugPrint('Notification permissions not granted');
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'restaurant_channel',
          'Restaurant Notifications',
          channelDescription: 'Channel for restaurant app notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
