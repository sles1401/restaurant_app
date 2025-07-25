import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'provider/theme_provider.dart';
import 'provider/restaurant_provider.dart';
import 'provider/favorite_provider.dart';

import 'data/api/restaurant_api_service.dart';
import 'data/db/database_helper.dart';

import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/favorite_list_page.dart';
import 'utils/theme.dart';

void main() {
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: RestaurantApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const RestaurantListPage(),
            routes: {'/favorite_list': (context) => const FavoriteListPage()},
          );
        },
      ),
    );
  }
}
