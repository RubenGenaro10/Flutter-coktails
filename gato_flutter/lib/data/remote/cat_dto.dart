import 'package:gato_flutter/domain/models/cat.dart';

class CatDto {
  final String id;
  final String name;
  final String origin;
  final String temperament;
  final int energyLevel;
  final int intelligence;
  final String description;
  final String referenceImageId;

  const CatDto({
    required this.id,
    required this.name,
    required this.origin,
    required this.temperament,
    required this.energyLevel,
    required this.intelligence,
    required this.description,
    required this.referenceImageId,
  });

  factory CatDto.fromJson(Map<String, dynamic> json) {
    return CatDto(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      origin: json['origin'] as String? ?? 'Unknown',
      temperament: json['temperament'] as String? ?? 'Unknown',
      energyLevel: (json['energy_level'] as num?)?.toInt() ?? 0,
      intelligence: (json['intelligence'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? 'No description available',
      referenceImageId: json['reference_image_id'] as String? ?? '',
    );
  }

  Cat toDomain() {
    return Cat(
      id: id,
      name: name,
      origin: origin,
      temperament: temperament,
      energyLevel: energyLevel,
      intelligence: intelligence,
      description: description,
      referenceImageId: referenceImageId,
      isFavorite: false,
    );
  }
}
