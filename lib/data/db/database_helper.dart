import 'package:flutter/foundation.dart' show kIsWeb;

import 'database_helper_web.dart' show DatabaseHelperWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/model/restaurant_list.dart';

import 'package:sqflite/sqflite.dart'
    show ConflictAlgorithm, getDatabasesPath, openDatabase;

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static dynamic _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorite = 'favorite';

  Future<dynamic> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDb();
    return _database!;
  }

  Future<dynamic> _initializeDb() async {
    if (kIsWeb) {
      final dbHelperWeb = DatabaseHelperWeb();
      return await dbHelperWeb.database;
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'restaurant.db');

      return openDatabase(
        path,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $_tableFavorite (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
          ''');
        },
        version: 1,
      );
    }
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableFavorite,
      restaurant.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final result = await db.query(_tableFavorite);
    return result.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Restaurant?> getFavoriteById(String id) async {
    final db = await database;
    final result = await db.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Restaurant.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableFavorite, where: 'id = ?', whereArgs: [id]);
  }
}
