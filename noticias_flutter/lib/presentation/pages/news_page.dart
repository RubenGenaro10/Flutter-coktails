import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias_flutter/core/enums/status.dart';
import 'package:noticias_flutter/presentation/blocs/news_bloc.dart';
import 'package:noticias_flutter/presentation/blocs/news_event.dart';
import 'package:noticias_flutter/presentation/blocs/news_state.dart';
import 'package:noticias_flutter/presentation/widgets/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NewsBloc>().add(const QueryChanged(query: ''));
                  },
                ),
              ),
              onChanged: (value) {
                context.read<NewsBloc>().add(QueryChanged(query: value));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                context.read<NewsBloc>().add(const GetAllNews());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Search'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state.status == Status.initial) {
                  return const Center(
                    child: Text('Enter a search term to find news'),
                  );
                }

                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == Status.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.message ?? 'An error occurred',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                if (state.newsList.isEmpty) {
                  return const Center(
                    child: Text('No news found'),
                  );
                }

                return ListView.builder(
                  itemCount: state.newsList.length,
                  itemBuilder: (context, index) {
                    return NewsCard(news: state.newsList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
