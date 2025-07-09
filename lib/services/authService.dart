import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject_flutter/config/APi.dart';

class AuthService {
  // Untuk menyimpan data data user ke dalam local storage
  final storage = const FlutterSecureStorage();

  // Untuk mengakses API
  final http.Client client = ApiConfig.client;
  final String baseUrl = ApiConfig.baseUrl;

  //Untuk pemanggilan API Login dan Registrasi dari backend ke frontend
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
        request.fields['store_location_id'] = storeLocation;
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

      if (response.statusCode == 200 && resData['status'] == 'success') {
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

  /// FORGOT PASSWORD
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'status': true, 'message': data['message']};
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Gagal menghubungi server: $e'};
    }
  }

  /// RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'status': true, 'message': data['message']};
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Reset password gagal',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Gagal menghubungi server: $e'};
    }
  }

  /// Update user profile with optional parameters
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
      request.headers['Accept'] = 'application/json';
      
      // Hanya tambahkan field yang tidak null
      if (name != null) request.fields['name'] = name;
      if (email != null) request.fields['email'] = email;
      if (phone != null) request.fields['phone'] = phone;
      if (password != null) request.fields['password'] = password;
      if (confirmPassword != null) request.fields['password_confirmation'] = confirmPassword;
      if (storeLocation != null) request.fields['store_location'] = storeLocation;

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
        final headers = await ApiConfig.getHeadersWithAuth();
        final response = await client.post(
          Uri.parse('$baseUrl/logout'),
          headers: headers,
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
      if (token == null) return null;
      
      final headers = await ApiConfig.getHeadersWithAuth();
      final response = await client.get(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data; // Sesuaikan dengan response Laravel
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
