import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';
import '../../data/model/restaurant_list.dart';

class DatabaseHelperWeb {
  static DatabaseHelperWeb? _instance;
  static Database? _database;

  DatabaseHelperWeb._internal() {
    _instance = this;
  }

  factory DatabaseHelperWeb() => _instance ?? DatabaseHelperWeb._internal();

  static const String _tableFavorite = 'favorite';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDb();
    return _database!;
  }

  Future<Database> _initializeDb() async {
    // Removed call to registerWebSql() as it is not defined in sqflite_common_ffi_web

    final dbPath = await databaseFactoryFfiWeb.getDatabasesPath();
    final path = join(dbPath, 'restaurant_web.db');

    return databaseFactoryFfiWeb.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
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
      ),
    );
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
