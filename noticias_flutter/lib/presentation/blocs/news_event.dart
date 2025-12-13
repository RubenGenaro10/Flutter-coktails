import 'package:noticias_flutter/domain/models/news.dart';

abstract class NewsEvent {
  const NewsEvent();
}

class GetAllNews extends NewsEvent {
  const GetAllNews();
}

class GetFavoriteNews extends NewsEvent {
  const GetFavoriteNews();
}

class QueryChanged extends NewsEvent {
  final String query;
  const QueryChanged({required this.query});
}

class ToggleFavoriteNews extends NewsEvent {
  final News news;
  const ToggleFavoriteNews({required this.news});
}
