import 'package:flutter/material.dart';
import '../data/api/restaurant_api_service.dart';
import '../data/model/restaurant_list.dart';
import '../utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurants();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';
  List<Restaurant> _displayedRestaurants = [];

  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;
  String get message => _message;
  List<Restaurant> get restaurants => _displayedRestaurants;

  Future<void> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.listRestaurants();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'No Data Available';
      } else {
        _state = ResultState.hasData;
        _restaurantResult = restaurant;
        _displayedRestaurants = restaurant.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error → $e';
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchResult = await apiService.searchRestaurant(query);
      if (searchResult.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'No restaurant found.';
        _displayedRestaurants = [];
      } else {
        _state = ResultState.hasData;
        _restaurantResult = searchResult;
        _displayedRestaurants = searchResult.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      _displayedRestaurants = [];
    }
    notifyListeners();
  }
}
