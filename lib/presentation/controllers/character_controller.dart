import 'package:get/get.dart';
import '../../data/repositories/character_repository.dart';
import '../../domain/entities/character.dart';

class CharacterController extends GetxController {
  final CharacterRepositoryImpl repository;
  CharacterController(this.repository);

  var characters = <CharacterEntity>[].obs;
  var isLoading = false.obs;
  int page = 1;

  @override
  void onInit() {
    loadCharacters();
    super.onInit();
  }

  // Fetch and append characters
  Future<void> loadCharacters() async {
    if (isLoading.value) return;
    isLoading(true);
    try {
      final list = await repository.getCharacters(page);
      if (page == 1) {
        characters.assignAll(list);
      } else {
        characters.addAll(list);
      }
      page++;
    } finally {
      isLoading(false);
    }
  }

  // Update character details locally
  Future<void> updateCharacter(CharacterEntity updatedChar) async {
    // SQLite via Repository
    await repository.saveLocalEdit(updatedChar);

    // Update list to changes in UI
    int index = characters.indexWhere((element) => element.id == updatedChar.id);
    if (index != -1) {
      characters[index] = updatedChar.copyWith(isEdited: true);
    }
  }

  //Toggle favorites locally
  Future<void> toggleFav(CharacterEntity character) async {
    final newStatus = !character.isFavorite;

    // status to SQLite
    await repository.toggleFavorite(character.id, newStatus);

    // Update local state
    int index = characters.indexWhere((element) => element.id == character.id);
    if (index != -1) {
      characters[index] = character.copyWith(isFavorite: newStatus);
    }
  }
}