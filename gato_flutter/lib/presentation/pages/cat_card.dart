import 'package:flutter/material.dart';
import 'package:gato_flutter/domain/models/cat.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  final VoidCallback onFavoritePressed;
  final bool isFavoriteCard;

  const CatCard({
    super.key,
    required this.cat,
    required this.onFavoritePressed,
    this.isFavoriteCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cat.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onFavoritePressed,
                  icon: Icon(
                    isFavoriteCard
                        ? Icons.delete_outline
                        : (cat.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline),
                    color: isFavoriteCard
                        ? Colors.redAccent
                        : (cat.isFavorite ? Colors.red : Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isFavoriteCard) ...[
              Text(
                'Origin: ${cat.origin}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Energy Level: ${cat.energyLevel}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                cat.description,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'reference_image_id: ${cat.referenceImageId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ] else ...[
              Text(
                'Temperament: ${cat.temperament}',
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Intelligence: ${cat.intelligence}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                'reference_image_id: ${cat.referenceImageId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
