import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_helper.dart';

class DailyReminderProvider extends ChangeNotifier {
  bool _isActive = false;
  bool get isActive => _isActive;

  DailyReminderProvider() {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isActive = prefs.getBool('daily_reminder') ?? false;
    notifyListeners();
  }

  Future<void> setActive(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
    _isActive = value;
    notifyListeners();

    if (value) {
      final helper = NotificationHelper();
      final hasPermission = await helper.checkNotificationPermission();
      if (hasPermission) {
        await helper.scheduleDailyReminder();
      } else {
        final granted = await helper.requestNotificationPermission();
        if (granted) {
          await helper.scheduleDailyReminder();
        }
      }
    } else {
      await NotificationHelper().cancelReminder();
    }
  }
}
