import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_flutter/core/enums/status.dart';
import 'package:gato_flutter/presentation/blocs/cats_bloc.dart';
import 'package:gato_flutter/presentation/blocs/cats_event.dart';
import 'package:gato_flutter/presentation/blocs/cats_state.dart';
import 'package:gato_flutter/presentation/pages/cat_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatsBloc>().add(const GetAllFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatsBloc, CatsState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No favorites yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CatsBloc>().add(const GetAllFavorites());
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            final cat = state.favorites[index];
            return CatCard(
              cat: cat,
              isFavoriteCard: true,
              onFavoritePressed: () {
                context.read<CatsBloc>().add(
                  ToggleFavoriteCat(cat: cat),
                );
              },
            );
          },
        );
      },
    );
  }
}
