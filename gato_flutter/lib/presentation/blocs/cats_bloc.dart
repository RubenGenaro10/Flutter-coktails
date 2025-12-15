import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_flutter/core/enums/status.dart';
import 'package:gato_flutter/domain/models/cat.dart';
import 'package:gato_flutter/domain/repositories/cat_repository.dart';
import 'package:gato_flutter/presentation/blocs/cats_event.dart';
import 'package:gato_flutter/presentation/blocs/cats_state.dart';

class CatsBloc extends Bloc<CatsEvent, CatsState> {
  final CatRepository repository;
  CatsBloc({required this.repository}) : super(const CatsState()) {
    on<GetAllCats>(_getAllCats);
    on<GetHomeImage>(_getHomeImage);
    on<ToggleFavoriteCat>(_toggleFavoriteCat);
    on<GetAllFavorites>(_getAllFavorites);
  }

  FutureOr<void> _getAllCats(
    GetAllCats event,
    Emitter<CatsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<Cat> cats = await repository.getAllCats();
      emit(state.copyWith(status: Status.success, cats: cats));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  FutureOr<void> _getHomeImage(
    GetHomeImage event,
    Emitter<CatsState> emit,
  ) async {
    try {
      final homeImage = await repository.getHomeImage();
      emit(state.copyWith(homeImage: homeImage));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  FutureOr<void> _toggleFavoriteCat(
    ToggleFavoriteCat event,
    Emitter<CatsState> emit,
  ) async {
    try {
      await repository.toggleFavoriteCat(event.cat);
      final List<Cat> updatedCats = state.cats.map((cat) {
        if (cat.id == event.cat.id) {
          return cat.copyWith(isFavorite: !cat.isFavorite);
        }
        return cat;
      }).toList();
      // Refresh favorites list to keep it in sync
      final favorites = await repository.getAllFavorites();
      emit(state.copyWith(cats: updatedCats, favorites: favorites));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  FutureOr<void> _getAllFavorites(
    GetAllFavorites event,
    Emitter<CatsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<Cat> favorites = await repository.getAllFavorites();
      emit(state.copyWith(status: Status.success, favorites: favorites));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
