import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_pridesys/presentation/page/home_navigation.dart';
import 'core/database/db_helper.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/character_repository.dart';
import 'presentation/controllers/character_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DbHelper();
  final httpClient = http.Client();

  final repository = CharacterRepositoryImpl(httpClient, dbHelper);

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
      home: const HomeNavigation(),
    );
  }
}