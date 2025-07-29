import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import '../../provider/restaurant_detail_provider.dart';
import '../../provider/favorite_provider.dart';
import '../../utils/result_state.dart';
import '../../data/api/restaurant_api_service.dart';
import '../../data/model/restaurant_hive_model.dart';
import '../widgets/loading_indicator.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(
            apiService: RestaurantApiService(),
            id: id,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Restaurant Detail"),
          actions: [
            Consumer2<RestaurantDetailProvider, FavoriteProvider>(
              builder: (context, detailProvider, favoriteProvider, _) {
                final result = detailProvider.result;

                if (result == null) return const SizedBox();

                final restaurant = result.restaurant;
                final isFavorite = favoriteProvider.isFavorite(restaurant.id);

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () async {
                    if (isFavorite) {
                      await favoriteProvider.removeFavorite(restaurant.id);
                    } else {
                      await favoriteProvider.addFavorite(
                        RestaurantHiveModel(
                          id: restaurant.id,
                          name: restaurant.name,
                          pictureId: restaurant.pictureId,
                          city: restaurant.city,
                          rating: restaurant.rating,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const LoadingIndicator();
            } else if (state.state == ResultState.hasData) {
              var restaurant = state.result!.restaurant;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text('${restaurant.city}, ${restaurant.address}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            restaurant.description,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Menu",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text("Foods:"),
                          Wrap(
                            spacing: 8,
                            children: restaurant.foods
                                .map((e) => Chip(label: Text(e.name)))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Text("Drinks:"),
                          Wrap(
                            spacing: 8,
                            children: restaurant.drinks
                                .map((e) => Chip(label: Text(e.name)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            } else {
              return const Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }
}
