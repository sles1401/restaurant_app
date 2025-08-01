class RestaurantDetailResult {
  final RestaurantDetail restaurant;

  RestaurantDetailResult({required this.restaurant});

  factory RestaurantDetailResult.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResult(
        restaurant: RestaurantDetail.fromJson(json["restaurant"]),
      );
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<Category> foods;
  final List<Category> drinks;
  final List<Category> categories;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.foods,
    required this.drinks,
    required this.categories,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        address: json["address"],
        rating: json["rating"].toDouble(),
        foods: List<Category>.from(
          json["menus"]["foods"].map((x) => Category.fromJson(x)),
        ),
        drinks: List<Category>.from(
          json["menus"]["drinks"].map((x) => Category.fromJson(x)),
        ),
        categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x)),
        ),
      );
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json["name"]);
}
