import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_search_result.dart';

class RestaurantApiServiceWithError extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    throw Exception('Failed to load restaurants');
  }

  @override
  Future<RestaurantDetailResult> getRestaurantDetail(String id) async {
    throw Exception('Failed to load restaurant detail');
  }

  @override
  Future<RestaurantResult> searchRestaurant(String query) async {
    throw Exception('Failed to search restaurants');
  }
}

void main() {
  group('RestaurantApiService Test', () {
    final apiService = RestaurantApiService();

    test('fetches list of restaurants', () async {
      RestaurantResult result = await apiService.listRestaurants();

      expect(
        result.restaurants,
        isNotEmpty,
        reason: 'No restaurants were fetched',
      );
    });

    test('throws exception when listRestaurants fails', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.listRestaurants(),
        throwsException,
      );
    });

    test('fetches detail of a restaurant', () async {
      const String sampleId = 'rqdv5juczeskfw1e867';

      RestaurantDetailResult result = await apiService.getRestaurantDetail(
        sampleId,
      );

      expect(
        result.restaurant.id,
        equals(sampleId),
        reason: 'ID does not match',
      );
    });

    test('throws exception when getRestaurantDetail fails', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.getRestaurantDetail('bad_id'),
        throwsException,
      );
    });

    test('searches for restaurants', () async {
      const String query = 'melting pot';

      RestaurantResult result = await apiService.searchRestaurant(query);

      expect(
        result.restaurants,
        isNotEmpty,
        reason: 'Search returned empty results',
      );
    });

    test('throws exception when searchRestaurant fails', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.searchRestaurant('bad_query'),
        throwsException,
      );
    });
  });
}
