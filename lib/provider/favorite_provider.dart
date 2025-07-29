import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/model/restaurant_hive_model.dart';

enum FavoriteState { Loading, HasData, NoData, Error }

class FavoriteProvider extends ChangeNotifier {
  late Box<RestaurantHiveModel> _favoriteBox;
  FavoriteState _state = FavoriteState.Loading;

  FavoriteState get state => _state;
  String _message = '';
  String get message => _message;

  List<RestaurantHiveModel> _favorites = [];
  List<RestaurantHiveModel> get favorites => _favorites;

  Set<String> _favoriteIds = {};

  FavoriteProvider() {
    _init();
  }

  void _init() async {
    try {
      _favoriteBox = Hive.box<RestaurantHiveModel>('favorite_restaurants');
      _favorites = _favoriteBox.values.toList();
      _favoriteIds = _favorites.map((r) => r.id).toSet();

      if (_favorites.isNotEmpty) {
        _state = FavoriteState.HasData;
      } else {
        _state = FavoriteState.NoData;
        _message = 'Belum ada restoran favorit';
      }

      notifyListeners();
    } catch (e) {
      _state = FavoriteState.Error;
      _message = 'Gagal memuat data favorit: $e';
      notifyListeners();
    }
  }

  Future<void> addFavorite(RestaurantHiveModel restaurant) async {
    try {
      await _favoriteBox.put(restaurant.id, restaurant);
      _favorites.add(restaurant);
      _favoriteIds.add(restaurant.id);
      _state = FavoriteState.HasData;
      notifyListeners();
    } catch (e) {
      _state = FavoriteState.Error;
      _message = 'Gagal menambahkan ke favorit: $e';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _favoriteBox.delete(id);
      _favorites.removeWhere((r) => r.id == id);
      _favoriteIds.remove(id);

      if (_favorites.isEmpty) {
        _state = FavoriteState.NoData;
        _message = 'Belum ada restoran favorit';
      }

      notifyListeners();
    } catch (e) {
      _state = FavoriteState.Error;
      _message = 'Gagal menghapus dari favorit: $e';
      notifyListeners();
    }
  }

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }
}
