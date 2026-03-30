import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_pridesys/presentation/page/home_navigation.dart';
import 'core/database/db_helper.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/character_repository.dart';
import 'presentation/controllers/character_controller.dart';

void main() async {
  // Required to ensure plugin tools (like SQLite) are ready before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Core Services [cite: 75, 77]
  final dbHelper = DbHelper();
  final httpClient = http.Client();

  // 2. Initialize Repository (The logic hub for Merging API & Local Edits) [cite: 32, 43, 61, 65]
  final repository = CharacterRepositoryImpl(httpClient, dbHelper);

  // 3. Dependency Injection via GetX [cite: 70, 72, 73]
  // We use Get.put to make these available to any screen immediately
  Get.put(repository);
  Get.put(CharacterController(repository));

  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.cartoonTheme,
      // Set the initial route to our navigation wrapper
      home: const HomeNavigation(),
    );
  }
}