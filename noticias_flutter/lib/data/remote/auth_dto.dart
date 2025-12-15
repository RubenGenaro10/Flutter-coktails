import 'package:noticias_flutter/domain/models/user.dart';

class AuthDto {
  final String token;
  final String firstName;
  final String lastName;
  final String email;

  const AuthDto({
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      token: json['token'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  User toDomain() {
    return User(
      token: token,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }
}
