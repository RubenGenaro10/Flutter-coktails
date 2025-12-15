import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias_flutter/data/local/news_dao.dart';
import 'package:noticias_flutter/data/remote/auth_service.dart';
import 'package:noticias_flutter/data/remote/news_service.dart';
import 'package:noticias_flutter/data/repositories/auth_repository_impl.dart';
import 'package:noticias_flutter/data/repositories/news_repository_impl.dart';
import 'package:noticias_flutter/presentation/blocs/auth_bloc.dart';
import 'package:noticias_flutter/presentation/blocs/auth_event.dart';
import 'package:noticias_flutter/presentation/blocs/news_bloc.dart';
import 'package:noticias_flutter/presentation/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Repositorio de noticias
    final newsRepository = NewsRepositoryImpl(
      service: NewsService(),
      dao: NewsDao(),
    );

    // Repositorio de autenticación
    final authRepository = AuthRepositoryImpl(
      authService: AuthService(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsBloc(repository: newsRepository),
        ),
        BlocProvider(
          create: (context) => AuthBloc(repository: authRepository)
            ..add(const CheckAuthStatus()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
