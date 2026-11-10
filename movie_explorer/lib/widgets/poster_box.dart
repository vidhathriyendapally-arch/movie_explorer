import 'package:flutter/material.dart';
import '../models/movie.dart';

// Gradient "poster" with the movie title. Fills whatever space its parent gives.
// compact = true shows only an icon (used for small thumbnails).
// If heroTag is given, the poster flies between screens (Hero animation).
class PosterBox extends StatelessWidget {
  final Movie movie;
  final String? heroTag;
  final bool compact;
  const PosterBox(
      {super.key, required this.movie, this.heroTag, this.compact = false});

  Widget _circle(double size, int alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(alpha),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final darker = Color.lerp(movie.poster, Colors.black, 0.6)!;

    final poster = Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [movie.poster, darker],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Soft decorative circles.
            Positioned(right: -24, top: -24, child: _circle(110, 24)),
            if (!compact)
              Positioned(left: -30, bottom: -30, child: _circle(90, 16)),
            Center(
              child: compact
                  ? const Icon(Icons.movie_outlined,
                      color: Colors.white70, size: 24)
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.movie_outlined,
                              color: Colors.white70, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${movie.year}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
    return heroTag == null ? poster : Hero(tag: heroTag!, child: poster);
  }
}
