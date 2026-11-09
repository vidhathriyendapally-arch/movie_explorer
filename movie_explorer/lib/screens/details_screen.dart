import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/poster_box.dart';
import '../widgets/rating_badge.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The movie is passed through Navigator.pushNamed(arguments: movie).
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final p = context.watch<MovieProvider>();
    final isFav = p.isFavorite(movie.id);
    final reviews = p.reviewsFor(movie.id);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Center(
        // Keeps content readable on wide desktop screens.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Large poster with Hero animation
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 300,
                  child: PosterBox(movie: movie, heroTag: 'poster_${movie.id}'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(movie.title,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                  RatingBadge(rating: movie.rating),
                ],
              ),
              const SizedBox(height: 4),
              Text('${movie.year} • ${movie.genre}'),
              const SizedBox(height: 12),
              Text(movie.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // Buttons
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => p.toggleFavorite(movie.id),
                    // Heart icon animates when toggled.
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFav)),
                    ),
                    label: Text(isFav ? 'Favorited' : 'Add to Favorites'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/review',
                        arguments: movie),
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Add Review'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Reviews
              Text('Reviews (${reviews.length})',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (reviews.isEmpty) const Text('No reviews yet. Be the first!'),
              for (final r in reviews)
                Card(
                  child: ListTile(
                    title: Text(r.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(r.comment),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text('${r.rating}/5'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
