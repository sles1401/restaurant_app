import 'package:flutter/material.dart';
import '../data/api/restaurant_api_service.dart';
import '../data/model/restaurant_detail.dart';
import '../utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApiService apiService;
  final String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    fetchRestaurantDetail();
  }

  RestaurantDetailResult? _restaurantDetail;
  late ResultState _state;
  String _message = '';

  RestaurantDetailResult? get result => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  Future<void> fetchRestaurantDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detail = await apiService.getRestaurantDetail(id);
      _state = ResultState.hasData;
      _restaurantDetail = detail;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error → $e';
    }
    notifyListeners();
  }
}
