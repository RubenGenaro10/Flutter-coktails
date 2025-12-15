import 'package:gato_flutter/domain/models/cat.dart';
import 'package:gato_flutter/domain/models/home_image.dart';

abstract class CatRepository {
  Future<List<Cat>> getAllCats();
  Future<void> toggleFavoriteCat(Cat cat);
  Future<List<Cat>> getAllFavorites();
  Future<HomeImage> getHomeImage();
}
