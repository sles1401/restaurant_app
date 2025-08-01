import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const dailyReminderKey = 'DAILY_REMINDER';
  static const darkThemeKey = 'DARK_THEME';

  // Daily Reminder
  Future<bool> get isDailyReminderActive async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(dailyReminderKey) ?? false;
  }

  Future<void> setDailyReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(dailyReminderKey, value);
  }

  // Dark Theme
  Future<bool> get isDarkTheme async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkThemeKey) ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkThemeKey, value);
  }
}
