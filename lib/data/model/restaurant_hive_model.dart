import 'package:hive/hive.dart';

part 'restaurant_hive_model.g.dart'; // ✅ WAJIB!

@HiveType(typeId: 1)
class RestaurantHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String pictureId;

  @HiveField(3)
  final String city;

  @HiveField(4)
  final double rating;

  RestaurantHiveModel({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });
}
