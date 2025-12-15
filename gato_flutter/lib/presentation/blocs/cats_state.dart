import 'package:gato_flutter/core/enums/status.dart';
import 'package:gato_flutter/domain/models/cat.dart';
import 'package:gato_flutter/domain/models/home_image.dart';

class CatsState {
  final Status status;
  final List<Cat> cats;
  final List<Cat> favorites;
  final HomeImage? homeImage;
  final String? message;

  const CatsState({
    this.status = Status.initial,
    this.cats = const [],
    this.favorites = const [],
    this.homeImage,
    this.message,
  });

  CatsState copyWith({
    Status? status,
    List<Cat>? cats,
    List<Cat>? favorites,
    HomeImage? homeImage,
    String? message,
  }) {
    return CatsState(
      status: status ?? this.status,
      cats: cats ?? this.cats,
      favorites: favorites ?? this.favorites,
      homeImage: homeImage ?? this.homeImage,
      message: message ?? this.message,
    );
  }
}
