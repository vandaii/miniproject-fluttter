import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthService {
  final String baseUrl = 'http://192.168.1.15:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  http.Client client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  // ====================================
  // AUTH
  // ====================================

  Future<bool> register({
    required String employeeId,
    required String name,
    required String email,
    required String password,
    required String confirmedPassword,
    required String phone,
    String? storeLocation,
    File? photoProfile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      var request = http.MultipartRequest('POST', uri)
        ..fields['employee_id'] = employeeId
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['password_confirmation'] = confirmedPassword
        ..fields['phone'] = phone;

      if (storeLocation != null) {
        request.fields['store_location'] = storeLocation;
      }

      if (photoProfile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo_profile', photoProfile.path),
        );
      }

      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      final resData = jsonDecode(response.body);
      print('Register Response: $resData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await storage.write(key: 'token', value: resData['access_token']);
        return true;
      } else {
        print('Register Failed: ${resData['message']}');
        return false;
      }
    } catch (e) {
      print('Register Error: $e');
      return false;
    }
  }

  Future<bool> login(String login, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': login, 'password': password}),
      );

      final resData = jsonDecode(response.body);
      print('Login Response: $resData');

      if (response.statusCode == 200 && resData['token'] != null) {
        await storage.write(key: 'token', value: resData['token']);
        return true;
      } else {
        print('Login failed: ${resData['message']}');
        return false;
      }
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? storeLocation,
    File? photoProfile,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      final uri = Uri.parse('$baseUrl/update');

      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (password != null) 'password': password,
        if (confirmPassword != null) 'password_confirmation': confirmPassword,
        if (storeLocation != null) 'store_location': storeLocation,
      });

      if (photoProfile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo_profile', photoProfile.path),
        );
      }

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final resData = jsonDecode(response.body);
      print('Update Response: $resData');

      return response.statusCode == 200;
    } catch (e) {
      print('Update Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await storage.read(key: 'token');
      if (token != null) {
        final response = await client.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        await storage.delete(key: 'token');
        if (response.statusCode != 200) {
          throw Exception('Logout failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      await storage.delete(key: 'token');
      print('Logout Error: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await client.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get User Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get User Error: $e');
      return null;
    }
  }

  // ====================================
  // DIRECT PURCHASE
  // ====================================

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

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['date'] = date
      ..fields['supplier'] = supplier
      ..fields['expense_type'] = expenseType
      ..fields['total_amount'] = totalAmount.toString()
      ..fields['note'] = note ?? '';

    for (int i = 0; i < items.length; i++) {
      request.fields['items[$i][item_name]'] = items[i]['item_name'];
      request.fields['items[$i][item_description]'] =
          items[i]['item_description'];
      request.fields['items[$i][quantity]'] = items[i]['quantity'].toString();
      request.fields['items[$i][price]'] = items[i]['price'].toString();
    }

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

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      String msg = 'Failed to create direct purchase';
      try {
        final err = json.decode(response.body);
        if (err is Map && err['message'] != null) {
          msg = err['message'];
        } else if (err is Map && err['error'] != null) {
          msg = err['error'];
        } else if (err is String) {
          msg = err;
        }
      } catch (_) {}
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
