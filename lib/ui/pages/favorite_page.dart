import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/favorite_provider.dart';
import '../widgets/restaurant_card.dart'; // kalau kamu punya komponen ini

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Restaurants")),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          if (provider.favorites.isEmpty) {
            return Center(child: Text("Belum ada restoran favorit."));
          }
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final restaurant = provider.favorites[index];
              return RestaurantCard(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}
