import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'utils/notification_helper.dart';
import 'utils/preferences_helper.dart';

import 'provider/theme_provider.dart';
import 'provider/restaurant_provider.dart';
import 'provider/favorite_provider.dart';
import 'provider/daily_reminder_provider.dart';

import 'data/api/restaurant_api_service.dart';
import 'data/model/restaurant_hive_model.dart';

import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/favorite_list_page.dart';
import 'ui/pages/settings_page.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk favorit
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  } else {
    await Hive.initFlutter();
  }

  Hive.registerAdapter(RestaurantHiveModelAdapter());
  await Hive.openBox<RestaurantHiveModel>('favorite_restaurants');

  // Inisialisasi timezone & notifikasi
  tz.initializeTimeZones();
  // Set default timezone to UTC, can be changed based on user preference
  tz.setLocalLocation(tz.getLocation('UTC'));
  final notificationHelper = NotificationHelper();
  await notificationHelper.initNotifications();
  await notificationHelper.requestNotificationPermission();

  // Inisialisasi PreferencesHelper untuk ThemeProvider
  final preferencesHelper = PreferencesHelper();

  runApp(MyApp(preferencesHelper: preferencesHelper));
}

class MyApp extends StatelessWidget {
  final PreferencesHelper preferencesHelper;

  const MyApp({super.key, required this.preferencesHelper});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(preferencesHelper: preferencesHelper),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: RestaurantApiService()),
        ),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => DailyReminderProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const RestaurantListPage(),
            routes: {
              '/favorite_list': (context) => const FavoriteListPage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
