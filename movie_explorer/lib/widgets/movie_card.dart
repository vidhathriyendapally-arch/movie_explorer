import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import 'poster_box.dart';
import 'rating_badge.dart';

// Reusable movie card. Fades in when it first appears, lifts on hover (web),
// and shows a heart if the movie is a favourite. Tap opens Details.
class MovieCard extends StatefulWidget {
  final Movie movie;
  final String? heroTag;
  const MovieCard({super.key, required this.movie, this.heroTag});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final movie = widget.movie;
    // select: rebuild only when this movie's favourite status changes.
    final isFav =
        context.select<MovieProvider, bool>((p) => p.isFavorite(movie.id));

    // Fade-in animation: opacity goes from 0 to 1.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(_hover ? 45 : 18),
                blurRadius: _hover ? 20 : 8,
                offset: Offset(0, _hover ? 10 : 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
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
                            child: PosterBox(
                                movie: movie, heroTag: widget.heroTag)),
                        Positioned(
                            top: 8,
                            right: 8,
                            child: RatingBadge(rating: movie.rating)),
                        if (isFav)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.favorite,
                                  size: 14, color: Color(0xFFE11D48)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${movie.year} • ${movie.genre}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
