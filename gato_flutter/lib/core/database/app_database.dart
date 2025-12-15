import 'package:gato_flutter/core/constants/database_constants.dart';
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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DatabaseConstants.catsTable} (
            id TEXT PRIMARY KEY,
            name TEXT,
            temperament TEXT,
            intelligence INTEGER,
            reference_image_id TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.catsTable}');
          await db.execute('''
            CREATE TABLE ${DatabaseConstants.catsTable} (
              id TEXT PRIMARY KEY,
              name TEXT,
              temperament TEXT,
              intelligence INTEGER,
              reference_image_id TEXT
            )
          ''');
        }
      },
    );
  }
}
