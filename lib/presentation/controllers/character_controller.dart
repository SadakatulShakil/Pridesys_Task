import 'package:get/get.dart';
import '../../data/repositories/character_repository.dart';
import '../../domain/entities/character.dart';

class CharacterController extends GetxController {
  final CharacterRepositoryImpl repository;
  CharacterController(this.repository);

  // Reactive list for the UI [cite: 6, 70]
  var characters = <CharacterEntity>[].obs;
  var isLoading = false.obs;
  int page = 1;

  @override
  void onInit() {
    loadCharacters();
    super.onInit();
  }

  // Fetch and append characters (supports pagination) [cite: 11, 16]
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

  // Requirement 2.4: Update character details locally [cite: 33, 43, 47]
  Future<void> updateCharacter(CharacterEntity updatedChar) async {
    // 1. Persist to SQLite via Repository
    await repository.saveLocalEdit(updatedChar);

    // 2. Update reactive list to reflect changes in UI immediately [cite: 44, 45, 46]
    int index = characters.indexWhere((element) => element.id == updatedChar.id);
    if (index != -1) {
      characters[index] = updatedChar.copyWith(isEdited: true);
    }
  }

  // Requirement 2.3: Toggle favorites locally [cite: 28, 29, 31]
  Future<void> toggleFav(CharacterEntity character) async {
    final newStatus = !character.isFavorite;

    // 1. Persist favorite status to SQLite [cite: 59, 101]
    await repository.toggleFavorite(character.id, newStatus);

    // 2. Update local state
    int index = characters.indexWhere((element) => element.id == character.id);
    if (index != -1) {
      characters[index] = character.copyWith(isFavorite: newStatus);
    }
  }
}