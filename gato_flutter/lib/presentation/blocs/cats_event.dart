import 'package:gato_flutter/domain/models/cat.dart';

abstract class CatsEvent {
  const CatsEvent();
}

class GetAllCats extends CatsEvent {
  const GetAllCats();
}

class GetHomeImage extends CatsEvent {
  const GetHomeImage();
}

class ToggleFavoriteCat extends CatsEvent {
  final Cat cat;
  const ToggleFavoriteCat({required this.cat});
}

class GetAllFavorites extends CatsEvent {
  const GetAllFavorites();
}
