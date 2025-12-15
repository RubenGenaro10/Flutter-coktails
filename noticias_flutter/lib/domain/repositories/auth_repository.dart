import 'package:noticias_flutter/domain/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
}
