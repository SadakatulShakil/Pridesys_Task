import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'rick_morty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Table for API Caching
        await db.execute('''
          CREATE TABLE characters(
            id INTEGER PRIMARY KEY, 
            name TEXT, status TEXT, species TEXT, 
            type TEXT, gender TEXT, image TEXT, 
            origin TEXT, location TEXT
          )
        ''');
        // Table for Favorites
        await db.execute('CREATE TABLE favorites(id INTEGER PRIMARY KEY)');
        // Table for Local Edits (Overrides)
        await db.execute('''
          CREATE TABLE overrides(
            id INTEGER PRIMARY KEY, 
            name TEXT, status TEXT, species TEXT, 
            type TEXT, gender TEXT, origin TEXT, location TEXT
          )
        ''');
      },
    );
  }
}