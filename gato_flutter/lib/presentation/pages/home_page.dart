import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String? imageUrl;

  const HomePage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageUrl != null)
            Expanded(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.pets,
                  size: 100,
                  color: Colors.orange,
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'My Cats',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
