import 'dart:async';
import 'package:noticias_flutter/core/enums/status.dart';
import 'package:noticias_flutter/domain/models/news.dart';
import 'package:noticias_flutter/domain/repositories/news_repository.dart';
import 'package:noticias_flutter/presentation/blocs/news_event.dart';
import 'package:noticias_flutter/presentation/blocs/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc({required this.repository}) : super(const NewsState()) {
    on<GetAllNews>(_getAllNews);
    on<GetFavoriteNews>(_getFavoriteNews);
    on<QueryChanged>(_queryChanged);
    on<ToggleFavoriteNews>(_toggleFavoriteNews);
  }

  FutureOr<void> _getAllNews(
    GetAllNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<News> newsList = await repository.getAllNews(state.query);
      emit(state.copyWith(status: Status.success, newsList: newsList));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  FutureOr<void> _getFavoriteNews(
    GetFavoriteNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<News> newsList = await repository.getFavoriteNews();
      emit(state.copyWith(status: Status.success, newsList: newsList));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  FutureOr<void> _queryChanged(
    QueryChanged event,
    Emitter<NewsState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  FutureOr<void> _toggleFavoriteNews(
    ToggleFavoriteNews event,
    Emitter<NewsState> emit,
  ) async {
    await repository.toggleFavoriteNews(event.news);
    final List<News> updatedNewsList = state.newsList.map((news) {
      if (news.title == event.news.title) {
        return news.copyWith(isFavorite: !news.isFavorite);
      }
      return news;
    }).toList();
    emit(state.copyWith(newsList: updatedNewsList));
  }
}
