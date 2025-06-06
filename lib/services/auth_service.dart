import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://your-api-url.com/api'; // Ganti sesuai backend kamu

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Simpan token kalau ada
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register({required Map<String, String> data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: data,
    );

    return response.statusCode == 200;
  }
}
