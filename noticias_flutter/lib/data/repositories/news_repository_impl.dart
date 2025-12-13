import 'package:noticias_flutter/data/local/news_dao.dart';
import 'package:noticias_flutter/data/local/news_entity.dart';
import 'package:noticias_flutter/data/remote/news_dto.dart';
import 'package:noticias_flutter/data/remote/news_service.dart';
import 'package:noticias_flutter/domain/models/news.dart';
import 'package:noticias_flutter/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsService service;
  final NewsDao dao;

  const NewsRepositoryImpl({required this.service, required this.dao});

  @override
  Future<List<News>> getAllNews(String query) async {
    try {
      final List<NewsDto> dtos = await service.getAllNews(query);
      final favoriteTitles = await dao.getAllFavoriteTitles();

      return dtos
          .map(
            (dto) => dto.toDomain().copyWith(
                  isFavorite: favoriteTitles.contains(dto.title),
                ),
          )
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<News>> getFavoriteNews() async {
    try {
      final List<NewsEntity> entities = await dao.getAllFavorites();
      return entities.map((entity) => entity.toDomain()).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> toggleFavoriteNews(News news) async {
    if (news.isFavorite) {
      await dao.delete(news.title);
    } else {
      await dao.insert(NewsEntity.fromDomain(news));
    }
  }
}
