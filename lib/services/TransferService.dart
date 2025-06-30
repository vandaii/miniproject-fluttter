import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject_flutter/config/APi.dart';
import 'package:dio/dio.dart';

class TransferService {

  final storage = FlutterSecureStorage();

  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;
    final Dio dio = Dio();


  Future<List<dynamic>> getTransferOutlist(String token) async {
    final  response = await http.get(
      Uri.parse('$baseUrl/transfer-out'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }else {
      throw Exception('Failed to load Transfer Out');
    }
  }
    Future<Map<String, dynamic>> createTransferOut({
    required String token,
    required String transferOutDate,
    required int destinationLocationId,
    required List<Map<String, dynamic>> items,
    List<String>? deliveryNotesPath,
    String? note,
  }) async {
    final formData = FormData.fromMap({
      'transfer_out_date': transferOutDate,
      'destination_location_id': destinationLocationId,
      'note': note ?? '',
      'items': items,
      if (deliveryNotesPath != null)
        'delivery_note': deliveryNotesPath.map((filePath) {
          return MultipartFile.fromFileSync(filePath, filename: filePath.split('/').last);
        }).toList(),
    });

    final response = await dio.post(
      '$baseUrl/transfer-out',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getTransferOutDetail(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transfer-out/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getTransferInList(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transfer-in'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load Transfer In');
    }
  }

  Future<Map<String, dynamic>> createTransferIn({
    required String token,
    required String transferOutNumber,
    required String receiptDate,
    required String transferDate,
    required String receiveName,
    required List<Map<String, dynamic>> items,
    List<String>? deliveryNotesPath,
    String? notes,
  }) async {
    final formData = FormData.fromMap({
      'transfer_out_number': transferOutNumber,
      'receipt_date': receiptDate,
      'transfer_date': transferDate,
      'receive_name': receiveName,
      'notes': notes ?? '',
      'items': items,
      if (deliveryNotesPath != null)
        'delivery_note': deliveryNotesPath.map((filePath) {
          return MultipartFile.fromFileSync(filePath, filename: filePath.split('/').last);
        }).toList(),
    });

    final response = await dio.post(
      '$baseUrl/transfer-in',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getTransferInDetail(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transfer-in/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
}