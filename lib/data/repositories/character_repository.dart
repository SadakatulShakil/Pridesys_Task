import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../../core/database/db_helper.dart';
import '../../domain/entities/character.dart';

class CharacterRepositoryImpl {
  final http.Client client;
  final DbHelper dbHelper;

  CharacterRepositoryImpl(this.client, this.dbHelper);

  Future<List<CharacterEntity>> getCharacters(int page) async {
    final db = await dbHelper.db;

    try {
      // 1. Fetch Remote Data [cite: 11]
      final response = await client.get(
          Uri.parse('https://rickandmortyapi.com/api/character?page=$page')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // 2. Cache API responses locally for offline support [cite: 49, 57]
        for (var item in results) {
          await db.insert('characters', {
            'id': item['id'],
            'name': item['name'],
            'status': item['status'],
            'species': item['species'],
            'type': item['type'],
            'gender': item['gender'],
            'image': item['image'],
            'origin': item['origin']['name'],
            'location': item['location']['name'],
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } catch (e) {
      // Fallback to cached data if offline [cite: 51, 107]
    }

    // 3. Perform Runtime Merge (API Cache + Favorites + Overrides) [cite: 61, 65, 98]
    final List<Map<String, dynamic>> cacheData = await db.query('characters');
    final List<Map<String, dynamic>> favData = await db.query('favorites');
    final List<Map<String, dynamic>> overrideData = await db.query('overrides');

    final favIds = favData.map((e) => e['id'] as int).toSet();
    final overrides = {for (var e in overrideData) e['id'] as int: e};

    return cacheData.map((json) {
      final id = json['id'] as int;
      final hasOverride = overrides.containsKey(id);
      final edit = overrides[id];

      // Local edits must override API/Cache data [cite: 44, 122]
      return CharacterEntity(
        id: id,
        name: hasOverride ? edit!['name'] : json['name'],
        status: hasOverride ? edit!['status'] : json['status'],
        species: hasOverride ? edit!['species'] : json['species'],
        type: hasOverride ? edit!['type'] : json['type'],
        gender: hasOverride ? edit!['gender'] : json['gender'],
        origin: hasOverride ? edit!['origin'] : json['origin'],
        location: hasOverride ? edit!['location'] : json['location'],
        image: json['image'],
        isFavorite: favIds.contains(id),
        isEdited: hasOverride,
      );
    }).toList();
  }

  // Requirement 2.4: Persist local edits [cite: 33, 47, 60]
  Future<void> saveLocalEdit(CharacterEntity c) async {
    final db = await dbHelper.db;
    await db.insert('overrides', {
      'id': c.id,
      'name': c.name,
      'status': c.status,
      'species': c.species,
      'type': c.type,
      'gender': c.gender,
      'origin': c.origin,
      'location': c.location,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Requirement 2.3: Persist favorites locally [cite: 29, 31, 59]
  Future<void> toggleFavorite(int id, bool isAdd) async {
    final db = await dbHelper.db;
    if (isAdd) {
      await db.insert('favorites', {'id': id},
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
    }
  }
}