import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../widgets/charector_card.dart';
import 'charector_detail_page.dart';

class FavoritesPage extends GetView<CharacterController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background to match the "Cartoon" aesthetic
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Vibrant Header
            SliverAppBar(
              floating: true,
              expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "MY FAVORITES".toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: Colors.black87,
                  ),
                ),
                centerTitle: true,
              ),
            ),

            // Reactive Content
            Obx(() {
              // Derived state: Filter characters marked as favorite [cite: 29]
              final favoriteCharacters = controller.characters
                  .where((char) => char.isFavorite)
                  .toList();

              // Empty State Handling [cite: 83]
              if (favoriteCharacters.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Large, playful icon for kids
                        Icon(Icons.heart_broken_rounded,
                            size: 100, color: Colors.grey.shade300),
                        const SizedBox(height: 20),
                        const Text(
                          "Your collection is empty!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const Text("Go back and heart some characters!"),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final character = favoriteCharacters[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CharacterCard(
                          character: character,
                          onTap: () => Get.to(
                                () => CharacterDetailPage(character: character),
                            transition: Transition.zoom, // Fun zoom transition
                          ),
                        ),
                      );
                    },
                    childCount: favoriteCharacters.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}