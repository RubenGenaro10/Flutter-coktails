import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_flutter/core/enums/status.dart';
import 'package:gato_flutter/presentation/blocs/cats_bloc.dart';
import 'package:gato_flutter/presentation/blocs/cats_event.dart';
import 'package:gato_flutter/presentation/blocs/cats_state.dart';
import 'package:gato_flutter/presentation/pages/cat_card.dart';

class CatsListPage extends StatefulWidget {
  const CatsListPage({super.key});

  @override
  State<CatsListPage> createState() => _CatsListPageState();
}

class _CatsListPageState extends State<CatsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatsBloc>().add(const GetAllCats());
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

        if (state.status == Status.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CatsBloc>().add(const GetAllCats());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.cats.isEmpty) {
          return const Center(
            child: Text('No cats available'),
          );
        }

        return ListView.builder(
          itemCount: state.cats.length,
          itemBuilder: (context, index) {
            final cat = state.cats[index];
            return CatCard(
              cat: cat,
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
