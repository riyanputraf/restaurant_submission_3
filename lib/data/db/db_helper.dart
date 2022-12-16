import 'package:restaurant/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorit = 'favorit';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restoapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableFavorit (
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
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  Future<void> addFavoritResto(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tableFavorit, restaurant.toJson());
  }

  Future<List<Restaurant>> getFavoritResto() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableFavorit);

    return results.map((result) => Restaurant.fromJson(result)).toList();
  }

  Future<Map> getFavoritFromId(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableFavorit,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavoritResto(String id) async {
    final db = await database;

    await db!.delete(
      _tableFavorit,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
