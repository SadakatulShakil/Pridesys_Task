abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String msg = "Server Error"]) : super(msg);
}

class CacheFailure extends Failure {
  CacheFailure([String msg = "Local Data Error"]) : super(msg);
}