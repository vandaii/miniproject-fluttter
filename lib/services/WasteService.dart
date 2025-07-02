import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miniproject_flutter/config/APi.dart';
import 'package:http/http.dart' as http;

class Wasteservice {
  final storage = FlutterSecureStorage();

  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;
}
