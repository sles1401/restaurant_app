import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/favorite_provider.dart';
import '../../data/model/restaurant_hive_model.dart';
import 'restaurant_detail_page.dart';

class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurants')),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, _) {
          if (favoriteProvider.state == FavoriteState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (favoriteProvider.state == FavoriteState.HasData) {
            final favorites = favoriteProvider.favorites;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return ListTile(
                  leading: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.city),
                  onTap: () {
                    // Navigasi ke detail restoran
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RestaurantDetailPage(id: restaurant.id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (favoriteProvider.state == FavoriteState.NoData) {
            return Center(child: Text(favoriteProvider.message));
          } else if (favoriteProvider.state == FavoriteState.Error) {
            return Center(child: Text(favoriteProvider.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
