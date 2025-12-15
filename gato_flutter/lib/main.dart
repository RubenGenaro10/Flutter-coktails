import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_flutter/data/local/cat_dao.dart';
import 'package:gato_flutter/data/remote/cat_service.dart';
import 'package:gato_flutter/data/repositories/cat_repository_impl.dart';
import 'package:gato_flutter/presentation/blocs/cats_bloc.dart';
import 'package:gato_flutter/presentation/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CatRepositoryImpl(
      service: CatService(),
      dao: CatDao(),
    );
    return BlocProvider(
      create: (context) => CatsBloc(repository: repository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Cats',
        home: MainPage(),
      ),
    );
  }
}
