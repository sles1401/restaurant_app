import 'package:flutter/material.dart';
import '../data/db/database_helper.dart';
import '../data/model/restaurant_list.dart';

enum FavoriteState { Loading, HasData, NoData, Error }

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  FavoriteState _state = FavoriteState.Loading;

  FavoriteState get state => _state;
  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  Set<String> _favoriteIds = {};

  FavoriteProvider() {
    _init();
  }

  void _init() async {
    try {
      _favorites = await _databaseHelper.getFavorites();
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

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.insertFavorite(restaurant);
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
      await _databaseHelper.removeFavorite(id);
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
