import 'package:noticias_flutter/core/enums/status.dart';
import 'package:noticias_flutter/domain/models/user.dart';

class AuthState {
  final Status status;
  final User? user;
  final String? message;
  final bool isAuthenticated;

  const AuthState({
    this.status = Status.initial,
    this.user,
    this.message,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    Status? status,
    User? user,
    String? message,
    bool? isAuthenticated,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
