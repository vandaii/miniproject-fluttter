import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.1.5:8000/api' ;

  // HTTP client with bad certificate callback
  static http.Client client = IOClient(
    // Create an HttpClient with a bad certificate callback
    HttpClient()
      // Set the bad certificate callback to always return true
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  // Returns a map of headers with authorization token
  static Future<Map<String, String>> getHeadersWithAuth() async {
    // Using FlutterSecureStorage to retrieve the token
    final storage = const FlutterSecureStorage();
    // Read the token from secure storage
    final token = await storage.read(key: 'token');
    // If token is null, return an empty map
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
