import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../widgets/charector_card.dart';
import 'charector_detail_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final CharacterController controller = Get.find<CharacterController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Requirement 2.1: Infinite scroll pagination implementation
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.loadCharacters(); // [cite: 81]
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Standardizing the AppBar so the title aligns with the refresh icon
            SliverAppBar(
              pinned: true, // Keeps the bar visible at the top
              floating: true, // Re-appears immediately when scrolling up
              snap: true,
              centerTitle: true,
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 0,
              // Title is now fixed in the bar to align with the refresh button
              title: Text(
                "CHARACTERS",
                style: TextStyle(
                  fontWeight: FontWeight.w800, // Vibrant but appropriate weight
                  letterSpacing: 1.5,
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.black87),
                  onPressed: () => controller.loadCharacters(),
                ),
              ],
            ),

            // Reactive Content [cite: 6, 94]
            Obx(() {
              // Initial Loading State [cite: 81, 103]
              if (controller.isLoading.value && controller.characters.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Empty or Error State Handling [cite: 82, 83]
              if (controller.characters.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off_rounded, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text("No characters found!", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => controller.loadCharacters(),
                          child: const Text("Retry Fetch"),
                        )
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100), // Bottom padding for the navigation bar
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      // Pagination Loading Indicator [cite: 81, 104]
                      if (index == controller.characters.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final character = controller.characters[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CharacterCard(
                          character: character,
                          onTap: () => Get.to(
                                () => CharacterDetailPage(character: character),
                            transition: Transition.cupertino,
                          ),
                        ),
                      );
                    },
                    // Infinite scroll: Adds 1 extra slot for the spinner [cite: 16, 81]
                    childCount: controller.characters.length + (controller.isLoading.value ? 1 : 0),
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