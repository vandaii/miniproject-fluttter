import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miniproject_flutter/config/APi.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject_flutter/models/StockOpnameModel.dart';
import '../config/Api.dart';

class StockOpnameService {
  final storage = const FlutterSecureStorage();
  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;

  // GET all with filter/search/pagination
  Future<StockOpnameModel> getStockOpnames({
    String? search,
    String? status,
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    try {
      String? token = await storage.read(key: 'token');

      final Map<String, String> queryParams = {
        'page': page.toString(),
        if (search != null) 'search': search,
        if (status != null) 'status': status,
        if (startDate != null && endDate != null) ...{
          'start_date': startDate,
          'end_date': endDate,
        },
      };

      final uri = Uri.parse(
        '$baseUrl/stock-opname',
      ).replace(queryParameters: queryParams);

      final response = await client.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch stock opname: $e');
    }
  }

  // GET Detail by ID
  Future<StockOpnameModel> getStockOpnameDetail(int id) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.get(
        Uri.parse('$baseUrl/stock-opname/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch detail: $e');
    }
  }

  // POST Create Stock Opname
  Future<StockOpnameModel> createStockOpname(Map<String, dynamic> data) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.post(
        Uri.parse('$baseUrl/stock-opname'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(data),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create stock opname: $e');
    }
  }
}
