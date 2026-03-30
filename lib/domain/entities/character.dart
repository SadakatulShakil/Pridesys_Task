class CharacterEntity {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String location;
  final String image;
  final bool isFavorite;
  final bool isEdited;

  CharacterEntity({
    required this.id, required this.name, required this.status,
    required this.species, required this.type, required this.gender,
    required this.origin, required this.location, required this.image,
    this.isFavorite = false,
    this.isEdited = false,
  });

  CharacterEntity copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? origin,
    String? location,
    bool? isFavorite,
    bool? isEdited,
  }) {
    return CharacterEntity(
      id: id,
      image: image,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}