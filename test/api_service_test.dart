import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

/// Mock API Service untuk error
class RestaurantApiServiceWithError extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    throw Exception('Gagal memuat daftar restoran');
  }

  @override
  Future<RestaurantDetailResult> getRestaurantDetail(String id) async {
    throw Exception('Gagal memuat detail restoran');
  }

  @override
  Future<RestaurantResult> searchRestaurant(String query) async {
    throw Exception('Gagal mencari restoran');
  }
}

/// Mock API Service untuk sukses
class RestaurantApiServiceMock extends RestaurantApiService {
  @override
  Future<RestaurantResult> listRestaurants() async {
    return RestaurantResult(
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Deskripsi Tes',
          pictureId: '14',
          city: 'Kota Tes',
          rating: 4.2,
        ),
      ],
    );
  }

  @override
  Future<RestaurantDetailResult> getRestaurantDetail(String id) async {
    return RestaurantDetailResult(
      restaurant: RestaurantDetail(
        id: id,
        name: 'Melting Pot',
        description: 'Detail Tes',
        pictureId: '14',
        city: 'Kota Tes',
        address: 'Alamat Tes',
        rating: 4.2,
        foods: [
          Category(name: 'Nasi Goreng'),
          Category(name: 'Mie Ayam'),
        ],
        drinks: [
          Category(name: 'Teh Manis'),
          Category(name: 'Kopi'),
        ],
        categories: [
          Category(name: 'Western'),
          Category(name: 'Casual Dining'),
        ],
      ),
    );
  }

  @override
  Future<RestaurantResult> searchRestaurant(String query) async {
    return RestaurantResult(
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Deskripsi Tes',
          pictureId: '14',
          city: 'Kota Tes',
          rating: 4.2,
        ),
      ],
    );
  }
}

void main() {
  group('Pengujian RestaurantApiService (Mock)', () {
    final apiService = RestaurantApiServiceMock();

    test('Berhasil mengambil daftar restoran', () async {
      RestaurantResult result = await apiService.listRestaurants();

      expect(result.restaurants, isNotEmpty, reason: 'Daftar restoran kosong');
      expect(result.restaurants.first.name, equals('Melting Pot'));
    });

    test('Gagal mengambil daftar restoran', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.listRestaurants(),
        throwsException,
      );
    });

    test('Berhasil mengambil detail restoran', () async {
      const String sampleId = 'rqdv5juczeskfw1e867';
      RestaurantDetailResult result = await apiService.getRestaurantDetail(
        sampleId,
      );

      expect(
        result.restaurant.id,
        equals(sampleId),
        reason: 'ID restoran tidak sesuai',
      );
      expect(
        result.restaurant.foods,
        isNotEmpty,
        reason: 'Daftar makanan kosong',
      );
      expect(
        result.restaurant.drinks,
        isNotEmpty,
        reason: 'Daftar minuman kosong',
      );
    });

    test('Gagal mengambil detail restoran', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.getRestaurantDetail('id_salah'),
        throwsException,
      );
    });

    test('Berhasil mencari restoran', () async {
      const String query = 'melting pot';
      RestaurantResult result = await apiService.searchRestaurant(query);

      expect(result.restaurants, isNotEmpty, reason: 'Hasil pencarian kosong');
      expect(result.restaurants.first.name, equals('Melting Pot'));
    });

    test('Gagal mencari restoran', () async {
      final badApiService = RestaurantApiServiceWithError();
      expect(
        () async => await badApiService.searchRestaurant('query_salah'),
        throwsException,
      );
    });
  });
}
