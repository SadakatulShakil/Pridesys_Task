import 'dart:convert';
import 'package:http/http.dart' as http;

import '../errors/exception.dart';

class HttpClient {
  final http.Client client;
  HttpClient(this.client);

  Future<dynamic> get(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      return _processResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
        throw NotFoundException();
      default:
        throw ServerException();
    }
  }
}