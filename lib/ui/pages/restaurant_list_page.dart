import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/result_state.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/loading_indicator.dart';
import 'restaurant_detail_page.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorite_list');
            },
          ),
          // ✅ Tombol menuju SettingsPage
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                final provider = Provider.of<RestaurantProvider>(
                  context,
                  listen: false,
                );
                if (query.isNotEmpty) {
                  provider.searchRestaurants(query);
                } else {
                  provider.fetchAllRestaurants();
                }
              },
            ),
          ),
          // List restoran
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, state, _) {
                switch (state.state) {
                  case ResultState.loading:
                    return const LoadingIndicator();
                  case ResultState.hasData:
                    return ListView.builder(
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = state.result.restaurants[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantDetailPage(id: restaurant.id),
                              ),
                            );
                          },
                          child: RestaurantCard(restaurant: restaurant),
                        );
                      },
                    );
                  case ResultState.noData:
                  case ResultState.error:
                    return Center(child: Text(state.message));
                  default:
                    return const Center(child: Text(''));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
