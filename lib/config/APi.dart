import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Custom IOClient dengan timeout default
class TimeoutIOClient extends IOClient {
  final Duration timeout;

  TimeoutIOClient(HttpClient client, {this.timeout = const Duration(seconds: 5)})
      : super(client);
}


class ApiConfig {
  // Gunakan IP yang sesuai dengan environment
  static const String baseUrl ='http://192.168.1.23:8000/api';
  // HTTP client dengan error handling dan timeout
  static http.Client get client {
    if (kIsWeb) {
      // Untuk web, gunakan client biasa
      return http.Client();
    } else {
      // Untuk mobile/desktop, gunakan IOClient dengan SSL bypass
      try {
        final httpClient = HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

        return TimeoutIOClient(httpClient, timeout: const Duration(seconds: 5));
      } catch (e) {
        print('Error creating IOClient: $e');
        return http.Client();
      }
    }
  }

  /// Returns a map of headers with authorization token
  static Future<Map<String, String>> getHeadersWithAuth() async {
    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      return {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    } catch (e) {
      print('Error getting headers: $e');
      return {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    }
  }

  /// Helper method untuk mengecek koneksi API
  static Future<bool> checkConnection() async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: '{"login":"admin@haus.com","password":"admin123"}',// hanya untuk contoh rest api data 
      );
      // Jika status 200 berarti user valid, jika 401/422 berarti API tetap responsif
      return response.statusCode == 200 || response.statusCode == 401 || response.statusCode == 422;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }
}
