import 'package:noticias_flutter/data/remote/auth_service.dart';
import 'package:noticias_flutter/domain/models/user.dart';
import 'package:noticias_flutter/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  const AuthRepositoryImpl({required this.authService});

  static const String _tokenKey = 'auth_token';

  @override
  Future<User> login(String email, String password) async {
    try {
      final authDto = await authService.login(email, password);
      final user = authDto.toDomain();
      
      // Guardar el token localmente
      await saveToken(user.token);
      
      return user;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
