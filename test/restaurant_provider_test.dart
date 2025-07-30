import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantApiServiceWithError extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    throw Exception('Failed to load restaurants');
  }
}

void main() {
  group('RestaurantProvider Test', () {
    test('State awal harus ResultState.loading', () {
      final provider = RestaurantProvider(apiService: RestaurantApiService());
      expect(provider.state, ResultState.loading);
    });

    test('Harus mengembalikan daftar restoran jika API sukses', () async {
      final provider = RestaurantProvider(apiService: RestaurantApiService());
      await provider.fetchAllRestaurants();
      expect(provider.state, ResultState.hasData);
      expect(provider.result.restaurants.isNotEmpty, true);
    });

    test('Harus mengembalikan error jika API gagal', () async {
      final provider = RestaurantProvider(
        apiService: RestaurantApiServiceWithError(),
      );

      await provider.fetchAllRestaurants();
      expect(provider.state, ResultState.error);
    });
  });
}
