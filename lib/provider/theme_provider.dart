import 'package:flutter/material.dart';
import '../utils/preferences_helper.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider({required this.preferencesHelper}) {
    _loadTheme();
  }

  void _loadTheme() async {
    // Ambil dari SharedPreferences
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;

    // Simpan ke SharedPreferences
    preferencesHelper.setDarkTheme(_isDarkTheme);

    notifyListeners();
  }
}
