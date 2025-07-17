import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miniproject_flutter/config/APi.dart';
import 'package:http/http.dart' as http;

class MaterialRequestService {
  final storage = const FlutterSecureStorage();
  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;

  // Get all Material Requests
  Future<dynamic> getMaterialRequests({
    String? search,
    String? status,
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    try {
      String? token = await storage.read(key: 'token');

      final queryParams = {
        'page': '$page',
        if (search != null) 'search': search,
        if (status != null) 'status': status,
        if (startDate != null && endDate != null) ...{
          'start_date': startDate,
          'end_date': endDate,
        },
      };

      final uri = Uri.parse(
        '$baseUrl/material-request',
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
      throw Exception('Failed to fetch Material Request: $e');
    }
  }

  // Show Material Request Detail
  Future<dynamic> getMaterialRequestDetail(int id) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.get(
        Uri.parse('$baseUrl/material-request/$id'),
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

  // ✅ Create New Material Request
  Future<dynamic> createMaterialRequest(Map<String, dynamic> data) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.post(
        Uri.parse('$baseUrl/material-request/add'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode(data),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  // ✅ Approve by Area Manager
  Future<dynamic> approveByAreaManager(int id) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.post(
        Uri.parse('$baseUrl/material-request/$id/approve-area-manager'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Area Manager approval failed: $e');
    }
  }

  // ✅ Approve by Accounting
  Future<dynamic> approveByAccounting(int id) async {
    try {
      String? token = await storage.read(key: 'token');

      final response = await client.post(
        Uri.parse('$baseUrl/material-request/$id/approve-accounting'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Accounting approval failed: $e');
    }
  }
}
