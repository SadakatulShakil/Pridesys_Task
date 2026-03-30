class ApiConstants {
  static const String baseUrl = "https://rickandmortyapi.com/api";
  static const String characterEndpoint = "$baseUrl/character";

  static String charactersPage(int page) => "$characterEndpoint?page=$page";
}