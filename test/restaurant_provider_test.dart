import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

/// Mock API Service untuk sukses (mengembalikan data dummy)
class RestaurantApiServiceMock extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    return RestaurantResult(
      restaurants: [
        Restaurant(
          id: '1',
          name: 'Restoran Dummy',
          description: 'Deskripsi Dummy',
          pictureId: '1',
          city: 'Kota Dummy',
          rating: 4.5,
        ),
      ],
    );
  }
}

/// Mock API Service untuk error
class RestaurantApiServiceWithError extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    throw Exception('Gagal memuat daftar restoran');
  }
}

void main() {
  group('Pengujian RestaurantProvider', () {
    test('State awal harus ResultState.loading', () {
      final provider = RestaurantProvider(
        apiService: RestaurantApiServiceMock(),
      );
      expect(provider.state, ResultState.loading);
    });

    test('Harus mengembalikan daftar restoran jika API sukses', () async {
      final provider = RestaurantProvider(
        apiService: RestaurantApiServiceMock(),
      );
      await provider.fetchAllRestaurants();
      expect(
        provider.state,
        ResultState.hasData,
        reason: 'Seharusnya state menjadi hasData',
      );
      expect(
        provider.result.restaurants.isNotEmpty,
        true,
        reason: 'Daftar restoran seharusnya tidak kosong',
      );
      expect(provider.result.restaurants.first.name, equals('Restoran Dummy'));
    });

    test('Harus mengembalikan error jika API gagal', () async {
      final provider = RestaurantProvider(
        apiService: RestaurantApiServiceWithError(),
      );

      await provider.fetchAllRestaurants();
      expect(
        provider.state,
        ResultState.error,
        reason: 'Seharusnya state menjadi error',
      );
    });
  });
}
