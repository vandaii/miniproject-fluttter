import 'dart:convert';

import 'package:miniproject_flutter/config/APi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ItemService {
  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;
  final storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> getItems() async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/items'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load items: ${response.statusCode}');
    }
  }
}
