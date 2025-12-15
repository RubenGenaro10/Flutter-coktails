import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_flutter/presentation/blocs/cats_bloc.dart';
import 'package:gato_flutter/presentation/blocs/cats_event.dart';
import 'package:gato_flutter/presentation/blocs/cats_state.dart';
import 'package:gato_flutter/presentation/pages/cats_list_page.dart';
import 'package:gato_flutter/presentation/pages/favorites_page.dart';
import 'package:gato_flutter/presentation/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    BlocBuilder<CatsBloc, CatsState>(
      builder: (context, state) {
        return HomePage(imageUrl: state.homeImage?.url);
      },
    ),
    const CatsListPage(),
    const FavoritesPage(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<CatsBloc>().add(const GetHomeImage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Cats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
