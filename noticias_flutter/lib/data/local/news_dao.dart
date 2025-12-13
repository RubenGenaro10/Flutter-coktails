import 'package:noticias_flutter/core/constants/database_constants.dart';
import 'package:noticias_flutter/core/database/app_database.dart';
import 'package:noticias_flutter/data/local/news_entity.dart';
import 'package:sqflite/sqflite.dart';

class NewsDao {
  Future<void> insert(NewsEntity news) async {
    final db = await AppDatabase().database;
    await db.insert(
      DatabaseConstants.newsTable,
      news.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String title) async {
    final db = await AppDatabase().database;
    await db.delete(
      DatabaseConstants.newsTable,
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<Set<String>> getAllFavoriteTitles() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConstants.newsTable);
    return maps.map((map) => map['title'] as String).toSet();
  }

  Future<List<NewsEntity>> getAllFavorites() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConstants.newsTable);
    return maps.map((map) => NewsEntity.fromMap(map)).toList();
  }
}
