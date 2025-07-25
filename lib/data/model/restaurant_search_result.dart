import 'restaurant_list.dart';

class RestaurantSearchResult {
  RestaurantSearchResult({required this.restaurants});

  final List<Restaurant> restaurants;

  factory RestaurantSearchResult.fromJson(Map<String, dynamic> json) {
    return RestaurantSearchResult(
      restaurants: List<Restaurant>.from(
        json['restaurants'].map((x) => Restaurant.fromJson(x)),
      ),
    );
  }
}
