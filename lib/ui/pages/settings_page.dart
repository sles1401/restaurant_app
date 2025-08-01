import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../provider/daily_reminder_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dailyReminderProvider = Provider.of<DailyReminderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Daily Reminder (11:00 AM)'),
            value: dailyReminderProvider.isActive,
            onChanged: (value) async {
              await dailyReminderProvider.setActive(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value
                        ? 'Daily Reminder diaktifkan'
                        : 'Daily Reminder dimatikan',
                  ),
                ),
              );
            },
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
