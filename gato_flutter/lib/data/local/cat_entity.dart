import 'package:gato_flutter/domain/models/cat.dart';

class CatEntity {
  final String id;
  final String name;
  final String temperament;
  final int intelligence;
  final String referenceImageId;

  const CatEntity({
    required this.id,
    required this.name,
    required this.temperament,
    required this.intelligence,
    required this.referenceImageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'temperament': temperament,
      'intelligence': intelligence,
      'reference_image_id': referenceImageId,
    };
  }

  factory CatEntity.fromMap(Map<String, dynamic> map) {
    return CatEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      temperament: map['temperament'] as String? ?? '',
      intelligence: (map['intelligence'] as num?)?.toInt() ?? 0,
      referenceImageId: map['reference_image_id'] as String? ?? '',
    );
  }

  factory CatEntity.fromDomain(Cat cat) {
    return CatEntity(
      id: cat.id,
      name: cat.name,
      temperament: cat.temperament,
      intelligence: cat.intelligence,
      referenceImageId: cat.referenceImageId,
    );
  }
}
