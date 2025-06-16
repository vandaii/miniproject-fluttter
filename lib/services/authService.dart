import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart'; // Import IOClient
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io'; // Import dart:io for HttpClient

class AuthService {
  final String baseUrl =
      'http://192.168.1.15:8000/api'; // Use your correct backend URL
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Function to ignore SSL certificate (development only)
  http.Client client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  // Register function - updated to handle multipart and image upload
  Future<bool> register({
    required String employeeId,
    required String name,
    required String email,
    required String password,
    required String confirmedPassword,
    required String phone,
    String? storeLocation,
    // File? photoProfile, // updated to File
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

      // if (photoProfile != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath('photo_profile', photoProfile.path),
      //   );
      // }

      // Send the request using IOClient
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Register Status Code: ${response.statusCode}');
      print('Register Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Register Error: $e');
      return false;
    }
  }

  // Login function
  Future<bool> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      await storage.write(key: 'token', value: responseData['access_token']);
      return true;
    } else {
      return false;
    }
  }

  // Logout function
  Future<void> logout() async {
    final token = await storage.read(key: 'token');
    final response = await client.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
    }
  }

  // Check login status
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
