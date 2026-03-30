import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/character.dart';
import '../controllers/character_controller.dart';

class CharacterDetailPage extends StatefulWidget {
  final CharacterEntity character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late TextEditingController _speciesController;
  late TextEditingController _typeController;
  late TextEditingController _genderController;
  late TextEditingController _originController;
  late TextEditingController _locationController;

  final CharacterController _controller = Get.find<CharacterController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character.name);
    _statusController = TextEditingController(text: widget.character.status);
    _speciesController = TextEditingController(text: widget.character.species);
    _typeController = TextEditingController(text: widget.character.type);
    _genderController = TextEditingController(text: widget.character.gender);
    _originController = TextEditingController(text: widget.character.origin);
    _locationController = TextEditingController(text: widget.character.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.character.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
              background: Hero(
                tag: 'hero-${widget.character.id}',
                child: Image.network(
                  widget.character.image,
                  fit: BoxFit.cover,
                ),
              ),
              collapseMode: CollapseMode.parallax, // Nice parallax effect
            ),

            actions: [
              Obx(() {
                final charInList = _controller.characters.firstWhere(
                      (c) => c.id == widget.character.id,
                  orElse: () => widget.character,
                );
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    child: IconButton(
                      icon: Icon(
                        charInList.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: charInList.isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _controller.toggleFav(charInList),
                    ),
                  ),
                );
              }),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.character.isEdited) _buildEditBadge(),

                  const Text("CHARACTER BIO",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.purple)),
                  const SizedBox(height: 15),

                  _buildCartoonField("Character Name", _nameController, Icons.person), // [cite: 35]
                  _buildCartoonField("Current Status", _statusController, Icons.monitor_heart), // [cite: 36]
                  _buildCartoonField("Species", _speciesController, Icons.pest_control), // [cite: 37]
                  _buildCartoonField("Gender", _genderController, Icons.transgender), // [cite: 39]
                  _buildCartoonField("Origin World", _originController, Icons.public), // [cite: 40]
                  _buildCartoonField("Current Location", _locationController, Icons.map), // [cite: 41]
                  _buildCartoonField("Type/Sub-species", _typeController, Icons.category), // [cite: 38]

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF97ce4c),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("SAVE EDITS",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      if (widget.character.isEdited) ...[
                        const SizedBox(width: 10),
                        IconButton.filled(
                          onPressed: _handleReset,
                          style: IconButton.styleFrom(backgroundColor: Colors.redAccent),
                          icon: const Icon(Icons.restore_rounded, color: Colors.white),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpdate() {
    final updated = widget.character.copyWith(
      name: _nameController.text,
      status: _statusController.text,
      species: _speciesController.text,
      type: _typeController.text,
      gender: _genderController.text,
      origin: _originController.text,
      location: _locationController.text,
      isEdited: true,
    );
    _controller.updateCharacter(updated);
    Get.back();
  }

  void _handleReset() {
    Get.defaultDialog(
      title: "Reset Character?",
      middleText: "This will remove your local edits.",
      textConfirm: "Reset",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Return to list
      },
    );
  }

  Widget _buildEditBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.orange, size: 18),
          SizedBox(width: 10),
          Text("YOU EDITED THIS CHARACTER",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartoonField(String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple.shade300, size: 20),
          labelText: label,
          labelStyle: TextStyle(color: Colors.purple.shade200, fontSize: 12),
          filled: true,
          fillColor: Colors.purple.withOpacity(0.03),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}