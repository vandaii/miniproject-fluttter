import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiConfig {
  static const String baseUrl = 'http://192.168.1.17:8000/api';

  static http.Client client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );
  //  static Future<Map<String, String>> getHeadersWithAuth() async {
  //   // Replace with your actual logic to get the token
  //   final storage = FlutterSecureStorage();
  //   final token = await storage.read(key: 'token');
  //   return {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //   };
  // }
}
