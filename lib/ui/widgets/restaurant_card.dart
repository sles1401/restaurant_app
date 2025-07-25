import 'package:flutter/material.dart';
import '../../data/model/restaurant_list.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
          width: 80,
          fit: BoxFit.cover,
        ),
        title: Text(restaurant.name),
        subtitle: Text('${restaurant.city} • ⭐ ${restaurant.rating}'),
      ),
    );
  }
}
