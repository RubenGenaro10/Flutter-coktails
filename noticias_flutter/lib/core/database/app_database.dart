import 'package:noticias_flutter/core/constants/database_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final _instance = AppDatabase._();
  factory AppDatabase() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database as Database;
  }

  Database? _database;

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DatabaseConstants.newsTable} (
            title TEXT PRIMARY KEY,
            author TEXT,
            description TEXT,
            url TEXT,
            url_to_image TEXT,
            published_at TEXT,
            content TEXT,
            source_id TEXT,
            source_name TEXT
          )
        ''');
      },
    );
  }
}
