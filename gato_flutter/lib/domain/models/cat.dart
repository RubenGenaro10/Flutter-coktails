class Cat {
  final String id;
  final String name;
  final String origin;
  final String temperament;
  final int energyLevel;
  final int intelligence;
  final String description;
  final String referenceImageId;
  final bool isFavorite;

  const Cat({
    required this.id,
    required this.name,
    required this.origin,
    required this.temperament,
    required this.energyLevel,
    required this.intelligence,
    required this.description,
    required this.referenceImageId,
    required this.isFavorite,
  });

  Cat copyWith({
    String? id,
    String? name,
    String? origin,
    String? temperament,
    int? energyLevel,
    int? intelligence,
    String? description,
    String? referenceImageId,
    bool? isFavorite,
  }) {
    return Cat(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      temperament: temperament ?? this.temperament,
      energyLevel: energyLevel ?? this.energyLevel,
      intelligence: intelligence ?? this.intelligence,
      description: description ?? this.description,
      referenceImageId: referenceImageId ?? this.referenceImageId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
