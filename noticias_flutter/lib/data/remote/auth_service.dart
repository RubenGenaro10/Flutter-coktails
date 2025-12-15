import 'dart:convert';
import 'dart:io';
import 'package:noticias_flutter/core/constants/auth_constants.dart';
import 'package:noticias_flutter/data/remote/auth_dto.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<AuthDto> login(String email, String password) async {
    final Uri uri = Uri.parse(AuthConstants.authBaseUrl).replace(
      path: '/${AuthConstants.loginEndpoint}',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return AuthDto.fromJson(json);
      }
      return Future.error('Login failed: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return Future.error('Login error: ${e.toString()}');
    }
  }
}
