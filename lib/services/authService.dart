import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthService {
  final String baseUrl = 'http://192.168.1.15:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  http.Client client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  /// ✅ REGISTER (dengan optional foto)
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

  /// ✅ LOGIN (pakai email / phone / employee_id)
  Future<bool> login(String login, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': login, 'password': password}),
      );

      final resData = jsonDecode(response.body);
      print('Login Response: $resData');

      if (response.statusCode == 200 && resData['access_token'] != null) {
        await storage.write(key: 'token', value: resData['access_token']);
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

  /// ✅ UPDATE PROFILE
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

  /// ✅ LOGOUT
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

  /// ✅ CEK LOGIN
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  /// ✅ GET CURRENT USER DATA
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
}
