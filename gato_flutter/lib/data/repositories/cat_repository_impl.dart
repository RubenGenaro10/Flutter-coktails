import 'package:gato_flutter/data/local/cat_dao.dart';
import 'package:gato_flutter/data/local/cat_entity.dart';
import 'package:gato_flutter/data/remote/cat_dto.dart';
import 'package:gato_flutter/data/remote/cat_service.dart';
import 'package:gato_flutter/domain/models/cat.dart';
import 'package:gato_flutter/domain/models/home_image.dart';
import 'package:gato_flutter/domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final CatService service;
  final CatDao dao;
  const CatRepositoryImpl({required this.service, required this.dao});

  @override
  Future<List<Cat>> getAllCats() async {
    try {
      final List<CatDto> dtos = await service.getAllCats();
      final favoriteIds = await dao.getAllFavoriteIds();

      return dtos
          .map(
            (dto) => dto.toDomain().copyWith(
              isFavorite: favoriteIds.contains(dto.id),
            ),
          )
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> toggleFavoriteCat(Cat cat) async {
    if (cat.isFavorite) {
      await dao.delete(cat.id);
    } else {
      await dao.insert(CatEntity.fromDomain(cat));
    }
  }

  @override
  Future<List<Cat>> getAllFavorites() async {
    try {
      final List<CatEntity> entities = await dao.getAllFavorites();
      return entities
          .map((entity) => Cat(
                id: entity.id,
                name: entity.name,
                origin: '',
                temperament: entity.temperament,
                energyLevel: 0,
                intelligence: entity.intelligence,
                description: '',
                referenceImageId: entity.referenceImageId,
                isFavorite: true,
              ))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<HomeImage> getHomeImage() async {
    try {
      final imageDto = await service.getHomeImage();
      return HomeImage(
        id: imageDto.id,
        url: imageDto.url,
        width: imageDto.width,
        height: imageDto.height,
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}
