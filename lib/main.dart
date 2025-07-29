import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'provider/theme_provider.dart';
import 'provider/restaurant_provider.dart';
import 'provider/favorite_provider.dart';

import 'data/api/restaurant_api_service.dart';
import 'data/model/restaurant_hive_model.dart';

import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/favorite_list_page.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  } else {
    await Hive.initFlutter();
  }

  Hive.registerAdapter(RestaurantHiveModelAdapter());
  await Hive.openBox<RestaurantHiveModel>('favorite_restaurants');

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
          create: (_) => FavoriteProvider(),
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
