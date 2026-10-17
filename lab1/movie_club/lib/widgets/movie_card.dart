import 'package:flutter/material.dart';

import '../models/movie_event.dart';
import '../utils/format.dart';

class MovieCard extends StatelessWidget {
  final MovieEvent movie;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _MovieAvatar(movie: movie),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateTime(movie.when),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      movie.online ? 'Online' : movie.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavourite,
                icon: Icon(
                  movie.favourite ? Icons.favorite : Icons.favorite_border,
                  color: movie.favourite ? colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieAvatar extends StatelessWidget {
  final MovieEvent movie;

  const _MovieAvatar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = movie.category.color(colorScheme);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundColor: categoryColor,
          foregroundColor: colorScheme.surface,
          child: Icon(movie.category.icon),
        ),
        if (movie.isFull || movie.freePlaces <= 5)
          Positioned(
            right: -8,
            bottom: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                movie.isFull ? 'FULL' : '${movie.freePlaces} left',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onErrorContainer),
              ),
            ),
          ),
      ],
    );
  }
}
