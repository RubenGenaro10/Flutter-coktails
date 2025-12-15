import 'dart:async';
import 'package:noticias_flutter/core/enums/status.dart';
import 'package:noticias_flutter/domain/repositories/auth_repository.dart';
import 'package:noticias_flutter/presentation/blocs/auth_event.dart';
import 'package:noticias_flutter/presentation/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final user = await repository.login(event.email, event.password);
      emit(state.copyWith(
        status: Status.success,
        user: user,
        isAuthenticated: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        message: e.toString(),
        isAuthenticated: false,
      ));
    }
  }

  FutureOr<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.logout();
      emit(state.copyWith(
        status: Status.initial,
        user: null,
        isAuthenticated: false,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await repository.getToken();
      if (token != null && token.isNotEmpty) {
        emit(state.copyWith(
          status: Status.success,
          isAuthenticated: true,
        ));
      } else {
        emit(state.copyWith(
          status: Status.initial,
          isAuthenticated: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        isAuthenticated: false,
      ));
    }
  }
}
