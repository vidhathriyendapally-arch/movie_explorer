import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'poster_box.dart';
import 'rating_badge.dart';

// Reusable movie card. Fades in when it first appears. Tap opens Details.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final String? heroTag;
  const MovieCard({super.key, required this.movie, this.heroTag});

  @override
  Widget build(BuildContext context) {
    // Fade-in animation: opacity goes from 0 to 1.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, '/details', arguments: movie),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster with rating badge on top (Stack).
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: PosterBox(movie: movie, heroTag: heroTag)),
                    Positioned(
                        top: 8, right: 8, child: RatingBadge(rating: movie.rating)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${movie.year} • ${movie.genre}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
