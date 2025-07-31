import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const dailyReminderKey = 'DAILY_REMINDER';

  Future<bool> get isDailyReminderActive async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(dailyReminderKey) ?? false;
  }

  Future<void> setDailyReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(dailyReminderKey, value);
  }
}
