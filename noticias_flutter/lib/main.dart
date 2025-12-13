import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias_flutter/data/local/news_dao.dart';
import 'package:noticias_flutter/data/remote/news_service.dart';
import 'package:noticias_flutter/data/repositories/news_repository_impl.dart';
import 'package:noticias_flutter/presentation/blocs/news_bloc.dart';
import 'package:noticias_flutter/presentation/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NewsRepositoryImpl(
      service: NewsService(),
      dao: NewsDao(),
    );

    return BlocProvider(
      create: (context) => NewsBloc(repository: repository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}
