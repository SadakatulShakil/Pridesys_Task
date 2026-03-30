import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/character.dart';
import '../controllers/character_controller.dart';

class CharacterCard extends StatelessWidget {
  final CharacterEntity character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    print('Hero_Tag: hero-${character.id}');
    final controller = Get.find<CharacterController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21), // Slightly less than container
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Hero(
                tag: 'hero-${DateTime.now()}',
                child: Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.black, width: 3)),
                  ),
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              character.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700, // Extra bold for kids' UI
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Requirement 2.3: Favorite Toggle [cite: 29]
                          GestureDetector(
                            onTap: () => controller.toggleFav(character),
                            child: Icon(
                              character.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: character.isFavorite ? Colors.red : Colors.black,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          _buildMiniBadge(character.status, _getStatusColor(character.status)),
                          const SizedBox(width: 8),
                          Text(
                            character.species,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (character.isEdited)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE68A), // Bright yellow
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: const Text(
                            "MODIFIED",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return const Color(0xFF97ce4c);
      case 'dead': return Colors.redAccent;
      default: return Colors.grey;
    }
  }
}