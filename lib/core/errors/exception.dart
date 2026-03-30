class ServerException implements Exception {
  final String message;
  ServerException([this.message = "The server is taking a nap. Try again!"]);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = "We couldn't find your data locally."]);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = "This character doesn't exist in this universe."]);
}