import 'package:noticias_flutter/domain/models/news.dart';

abstract class NewsRepository {
  Future<List<News>> getAllNews(String query);
  Future<List<News>> getFavoriteNews();
  Future<void> toggleFavoriteNews(News news);
}
