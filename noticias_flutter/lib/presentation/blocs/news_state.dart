import 'package:noticias_flutter/core/enums/status.dart';
import 'package:noticias_flutter/domain/models/news.dart';

class NewsState {
  final Status status;
  final List<News> newsList;
  final String query;
  final String? message;

  const NewsState({
    this.status = Status.initial,
    this.newsList = const [],
    this.query = '',
    this.message,
  });

  NewsState copyWith({
    Status? status,
    List<News>? newsList,
    String? query,
    String? message,
  }) {
    return NewsState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      query: query ?? this.query,
      message: message ?? this.message,
    );
  }
}
