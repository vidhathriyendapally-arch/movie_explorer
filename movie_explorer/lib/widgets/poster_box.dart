import 'package:flutter/material.dart';
import '../models/movie.dart';

// Gradient "poster" with the movie title. Fills whatever space its parent gives.
// If heroTag is given, the poster flies between screens (Hero animation).
class PosterBox extends StatelessWidget {
  final Movie movie;
  final String? heroTag;
  const PosterBox({super.key, required this.movie, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final poster = Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [movie.poster, Color.lerp(movie.poster, Colors.black, 0.6)!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.movie, color: Colors.white70, size: 32),
              const SizedBox(height: 8),
              Text(
                movie.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
    return heroTag == null ? poster : Hero(tag: heroTag!, child: poster);
  }
}
