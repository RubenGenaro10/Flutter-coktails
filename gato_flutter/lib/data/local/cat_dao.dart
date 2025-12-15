import 'package:gato_flutter/core/constants/database_constants.dart';
import 'package:gato_flutter/core/database/app_database.dart';
import 'package:gato_flutter/data/local/cat_entity.dart';

class CatDao {
  Future<void> insert(CatEntity cat) async {
    final db = await AppDatabase().database;
    await db.insert(DatabaseConstants.catsTable, cat.toMap());
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase().database;
    await db.delete(
      DatabaseConstants.catsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Set<String>> getAllFavoriteIds() async {
    final db = await AppDatabase().database;
    final List maps = await db.query(DatabaseConstants.catsTable);
    return maps.map((map) => map['id'] as String).toSet();
  }

  Future<List<CatEntity>> getAllFavorites() async {
    final db = await AppDatabase().database;
    final List maps = await db.query(DatabaseConstants.catsTable);
    return maps.map((map) => CatEntity.fromMap(map)).toList();
  }
}
