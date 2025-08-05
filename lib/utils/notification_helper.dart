import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Initialize timezone data
    tzdata.initializeTimeZones();

    // Get device timezone and set local location
    final String deviceTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(deviceTimeZone));

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isGranted) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> checkNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  Future<void> scheduleDailyReminder({BuildContext? context}) async {
    // Check notification permission first
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission) {
      final granted = await requestNotificationPermission();
      if (!granted) {
        if (context != null) {
          _showNotificationPermissionDialog(context);
        }
        return;
      }
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Jangan lupa makan siang!',
        'Yuk cek restoran favorit kamu hari ini!',
        _nextInstanceOf11AM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Reminder',
            channelDescription: 'Pengingat harian makan siang',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        // Show user-friendly message to enable exact alarms in system settings
        if (context != null) {
          _showExactAlarmPermissionDialog(context);
        }
      } else {
        print('Failed to schedule daily reminder: $e');
      }
    } catch (e) {
      print('Failed to schedule daily reminder: $e');
    }
  }

  Future<void> cancelReminder() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  tz.TZDateTime _nextInstanceOf11AM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _showExactAlarmPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'Aplikasi membutuhkan izin untuk menjadwalkan alarm tepat waktu. '
            'Silakan aktifkan "Exact Alarms" untuk aplikasi ini di pengaturan sistem.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotificationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Izin Notifikasi Diperlukan'),
          content: const Text(
            'Untuk dapat menerima pengingat harian, silakan berikan izin notifikasi untuk aplikasi ini.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
