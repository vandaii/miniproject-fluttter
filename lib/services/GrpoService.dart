import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miniproject_flutter/config/APi.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class GrpoService {
  final storage = FlutterSecureStorage();
  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;

  /// Ambil semua GRPO
  Future<List<dynamic>> fetchAllGrpo() async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/grpo'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print('FetchAllGrpo - Status: ${response.statusCode}');
    print('FetchAllGrpo - Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['data'] ?? [];
      print('FetchAllGrpo - Data count: ${result.length}');
      return result;
    } else {
      throw Exception('Gagal mengambil data GRPO');
    }
  }

  /// Pencarian GRPO berdasarkan kata kunci dan/atau rentang tanggal
  Future<List<dynamic>> searchGrpo({
    String? keyword,
    String? startDate,
    String? endDate,
  }) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/grpo/search').replace(
      queryParameters: {
        if (keyword != null && keyword.isNotEmpty) 'search': keyword,
        if (startDate != null && endDate != null) ...{
          'start_date': startDate,
          'end_date': endDate,
        },
      },
    );

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Gagal mencari GRPO');
    }
  }

  /// Ambil daftar PO dengan status "shipping"
  Future<List<dynamic>> fetchShippingPOs() async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/grpo/filter-shipping'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print('FetchShippingPOs - Status: ${response.statusCode}');
    print('FetchShippingPOs - Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['data'] ?? [];
      print('FetchShippingPOs - Data count: ${result.length}');
      return result;
    } else {
      throw Exception('Gagal mengambil PO shipping');
    }
  }

  /// Ambil detail PO berdasarkan ID yang statusnya "shipping"
  Future<Map<String, dynamic>> getShippingPODetail(int id) async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/grpo/shipping/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? {};
    } else {
      throw Exception('Gagal mengambil detail shipping PO');
    }
  }

  /// Ambil GRPO yang sudah received
  Future<List<dynamic>> fetchReceivedGrpo() async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/grpo/filter-received'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print('FetchReceivedGrpo - Status: ${response.statusCode}');
    print('FetchReceivedGrpo - Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['data'] ?? [];
      print('FetchReceivedGrpo - Data count: ${result.length}');
      return result;
    } else {
      throw Exception('Gagal mengambil GRPO yang sudah received');
    }
  }

  /// Ambil detail GRPO yang sudah received berdasarkan ID
  Future<Map<String, dynamic>> getReceivedGrpoDetail(int id) async {
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse('$baseUrl/grpo/received/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? {};
    } else {
      throw Exception('Gagal mengambil detail GRPO');
    }
  }

  /// Test koneksi ke endpoint GRPO
  Future<bool> testConnection() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await client.get(
        Uri.parse('$baseUrl/grpo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Test connection status: ${response.statusCode}');
      print('Test connection body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Test connection error: $e');
      return false;
    }
  }

  /// Simpan data GRPO baru
  Future<Map<String, dynamic>> createGrpo({
    required String noPo,
    required String receiveDate,
    required String expenseType,
    required String shipperName,
    required List<File> packingSlipFiles,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final uri = Uri.parse('$baseUrl/grpo/add');
    print('Creating GRPO request to: $uri');

    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Basic fields
    request.fields['no_po'] = noPo;
    request.fields['receive_date'] = receiveDate;
    request.fields['expense_type'] = expenseType;
    request.fields['shipper_name'] = shipperName;
    if (notes != null && notes.isNotEmpty) {
      request.fields['notes'] = notes;
    }

    // Upload packing slip files
    if (packingSlipFiles.isNotEmpty) {
      for (int i = 0; i < packingSlipFiles.length; i++) {
        File file = packingSlipFiles[i];
        String fileName = file.path.split('/').last;
        final mimeTypeData =
            lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];

        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'packing_slip[$i]',
              file.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
              filename: fileName,
            ),
          );
          print('Added file: $fileName');
        } catch (e) {
          print('Error adding file $fileName: $e');
        }
      }
    }

    // Add items - pastikan format sesuai backend
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      request.fields['items[$i][item_code]'] = item['item_code'] ?? '';
      request.fields['items[$i][item_name]'] = item['item_name'] ?? '';
      request.fields['items[$i][quantity]'] = (item['quantity'] ?? 1)
          .toString();
      request.fields['items[$i][unit]'] = item['unit'] ?? 'PCS';
    }

    print('--- Creating GRPO ---');
    print('URL: ${request.method} ${request.url}');
    print('Headers: ${request.headers}');
    print('Fields: ${request.fields}');
    if (request.files.isNotEmpty) {
      print('Files: ${request.files.map((e) => e.filename).toList()}');
    }

    try {
      print('Sending request...');
      final streamed = await request.send();
      print('Request sent, status: ${streamed.statusCode}');

      final response = await http.Response.fromStream(streamed);
      print('Response received');
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('--- End GRPO ---');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        String msg;
        try {
          final err = json.decode(response.body);
          print('Error response parsed: $err');
          if (err is Map && err['message'] != null) {
            msg = err['message'];
            if (err['errors'] != null && err['errors'] is Map) {
              final errors = err['errors'] as Map;
              final errorMessages = errors.values
                  .map((e) => (e as List).join('\n'))
                  .join('\n');
              msg += '\n\nDetails:\n$errorMessages';
            }
          } else if (err is Map && err['error'] != null) {
            msg = err['error'];
          } else {
            msg = 'Request failed with status: ${response.statusCode}.';
          }
        } catch (parseError) {
          print('Error parsing response: $parseError');
          msg =
              'Request failed with status: ${response.statusCode}. Full response: ${response.body}';
        }
        throw Exception(msg);
      }
    } catch (e) {
      print('Exception during request: $e');
      if (e is SocketException) {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      }
      rethrow;
    }
  }
}
