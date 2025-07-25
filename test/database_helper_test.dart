import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbHelper = DatabaseHelper();

  final testRestaurant = Restaurant(
    id: 'r123',
    name: 'Test Resto',
    description: 'Enak banget',
    pictureId: 'pic123',
    city: 'Bandung',
    rating: 4.5,
  );

  test('Insert and Get Favorite Restaurant from DB', () async {
    // Insert
    await dbHelper.insertFavorite(testRestaurant);

    // Get by ID
    final fetched = await dbHelper.getFavoriteById('r123');

    expect(fetched?.id, equals('r123'));
    expect(fetched?.name, equals('Test Resto'));
  });

  test('Remove Favorite Restaurant from DB', () async {
    await dbHelper.removeFavorite('r123');

    final fetched = await dbHelper.getFavoriteById('r123');
    expect(fetched, isNull);
  });
}
