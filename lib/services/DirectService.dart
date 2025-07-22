// ignore_for_file: unnecessary_type_check

import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:miniproject_flutter/config/APi.dart';
import 'dart:ui';

class DirectService {
  final storage = FlutterSecureStorage();

  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> getDirectPurchases({
    String? search,
    String? status,
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/direct-purchase').replace(
      queryParameters: {
        if (search != null) 'search': search,
        if (status != null) 'status': status,
        if (startDate != null && endDate != null) ...{
          'start_date': startDate,
          'end_date': endDate,
        },
        'page': page.toString(),
      },
    );

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load direct purchases');
    }
  }

  Future<Map<String, dynamic>> getDirectPurchaseDetail(int id) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/direct-purchase/$id');

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load direct purchase detail');
    }
  }

  Future<Map<String, dynamic>> createDirectPurchase({
    required String date,
    required String supplier,
    required String expenseType,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    String? note,
    List<File>? purchaseProofs,
  }) async {
    final token = await storage.read(key: 'token');
    var uri = Uri.parse('$baseUrl/direct-purchase/add');

    // Jika tidak ada file, kirim sebagai JSON
    if (purchaseProofs == null || purchaseProofs.isEmpty) {
      final safeItems = (items is List && items.isNotEmpty && items.first is Map<String, dynamic>) ? items : (items is List ? items : []);
      final body = {
        'date': date,
        'supplier': supplier,
        'expense_type': expenseType,
        'items': safeItems,
        'total_amount': totalAmount,
        'note': note ?? '',
      };
      print('DEBUG kirim direct purchase (json): ' + jsonEncode(body));
      final response = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      print('DEBUG response direct purchase: ' + response.body);
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        String msg = 'Failed to create direct purchase';
        try {
          final err = json.decode(response.body);
          if (err is Map && err['message'] != null) {
            msg = err['message'];
          } else if (err is Map && err['errors'] != null) {
            final errors = err['errors'] as Map;
            msg = errors.entries
                .map((e) => '${e.key}: ${e.value.join(', ')}')
                .join('\n');
          } else if (err is Map && err['error'] != null) {
            msg = err['error'];
          } else if (err is String) {
            msg = err;
          }
        } catch (e) {
          print(
            'Error parsing response in createDirectPurchase: '
            'Status: \\${response.statusCode}\nBody: \\${response.body}\nError: \\${e.toString()}',
          );
        }
        print(
          'createDirectPurchase error: Status: \\${response.statusCode}, Body: \\${response.body}',
        );
        throw Exception(msg);
      }
    }

    // Jika ada file, gunakan multipart, items dikirim sebagai array field
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['date'] = date
      ..fields['supplier'] = supplier
      ..fields['expense_type'] = expenseType
      ..fields['total_amount'] = totalAmount.toString()
      ..fields['note'] = note ?? '';

    // Kirim items sebagai array, bukan JSON string
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      request.fields['items[$i][item_name]'] = item['item_name'];
      request.fields['items[$i][item_description]'] = item['item_description'];
      request.fields['items[$i][quantity]'] = item['quantity'].toString();
      request.fields['items[$i][price]'] = item['price'].toString();
      request.fields['items[$i][unit]'] = item['unit'];
    }

    // ignore: unnecessary_null_comparison
    if (purchaseProofs != null) {
      for (var file in purchaseProofs) {
        final mimeTypeData =
            lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
        final multipartFile = await http.MultipartFile.fromPath(
          'purchase_proof[]',
          file.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('DEBUG response direct purchase (multipart): ' + response.body);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      String msg = 'Failed to create direct purchase';
      try {
        final err = json.decode(response.body);
        if (err is Map && err['message'] != null) {
          msg = err['message'];
        } else if (err is Map && err['errors'] != null) {
          final errors = err['errors'] as Map;
          msg = errors.entries
              .map((e) => '${e.key}: ${e.value.join(', ')}')
              .join('\n');
        } else if (err is Map && err['error'] != null) {
          msg = err['error'];
        } else if (err is String) {
          msg = err;
        }
      } catch (e) {
        print(
          'Error parsing response in createDirectPurchase: '
          'Status: \\${response.statusCode}\nBody: \\${response.body}\nError: \\${e.toString()}',
        );
      }
      print(
        'createDirectPurchase error: Status: \\${response.statusCode}, Body: \\${response.body}',
      );
      throw Exception(msg);
    }
  }

  Future<bool> deleteDirectPurchase(int id) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/direct-purchase/$id');

    final response = await client.delete(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> approveByAreaManager(
    int id,
    bool approve,
  ) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/direct-purchase/$id/approve-area-manager');

    final response = await client.post(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'approve_area_manager': approve.toString()},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to approve by Area Manager');
    }
  }

  Future<Map<String, dynamic>> approveByAccounting(int id) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/direct-purchase/$id/approve-accounting');

    final response = await client.post(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to approve by Accounting');
    }
  }
}
