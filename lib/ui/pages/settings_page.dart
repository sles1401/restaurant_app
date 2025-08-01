import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/notification_helper.dart';
import '../../provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isActive = prefs.getBool('daily_reminder') ?? false;
    });
  }

  Future<void> _onSwitchChanged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('daily_reminder', value);

    setState(() => _isActive = value);

    if (value) {
      await NotificationHelper().scheduleDailyReminder();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily Reminder diaktifkan')),
      );
    } else {
      await NotificationHelper().cancelReminder();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Daily Reminder dimatikan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Daily Reminder (11:00 AM)'),
            value: _isActive,
            onChanged: _onSwitchChanged,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: themeProvider.isDarkTheme,
            onChanged: (_) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
