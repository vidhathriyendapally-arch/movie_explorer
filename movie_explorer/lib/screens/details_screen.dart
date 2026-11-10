import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/poster_box.dart';
import '../widgets/rating_badge.dart';
import 'home_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The movie is passed through Navigator.pushNamed(arguments: movie).
    // After a browser refresh it is lost, so we go back to Home instead of crashing.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Movie) return const HomeScreen();
    final movie = args;

    final p = context.watch<MovieProvider>();
    final scheme = Theme.of(context).colorScheme;
    final isFav = p.isFavorite(movie.id);
    final reviews = p.reviewsFor(movie.id);
    final double? average = reviews.isEmpty
        ? null
        : reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;

    // Large poster with Hero animation
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: PosterBox(movie: movie, heroTag: 'poster_${movie.id}'),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            RatingBadge(rating: movie.rating),
            _InfoPill(text: '${movie.year}'),
            _InfoPill(text: movie.genre),
          ],
        ),
        const SizedBox(height: 16),
        Text(movie.description,
            style: const TextStyle(fontSize: 16, height: 1.5)),
        const SizedBox(height: 20),

        // Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => p.toggleFavorite(movie.id),
              style: isFav
                  ? FilledButton.styleFrom(
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.onPrimaryContainer,
                    )
                  : null,
              // Heart icon animates when toggled.
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFav)),
              ),
              label: Text(isFav ? 'Favorited' : 'Add to Favorites'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/review', arguments: movie),
              icon: const Icon(Icons.rate_review),
              label: const Text('Add Review'),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive: side by side on wide screens, stacked on mobile.
          final wide = constraints.maxWidth >= 800;

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 300, height: 450, child: poster),
                            const SizedBox(width: 32),
                            Expanded(child: info),
                          ],
                        )
                      else ...[
                        SizedBox(
                            height: 300, width: double.infinity, child: poster),
                        const SizedBox(height: 20),
                        info,
                      ],
                      const SizedBox(height: 32),

                      // Reviews
                      Row(
                        children: [
                          Expanded(
                            child: Text('Reviews (${reviews.length})',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800)),
                          ),
                          if (average != null) ...[
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFD97706), size: 22),
                            const SizedBox(width: 4),
                            Text('${average.toStringAsFixed(1)}/5',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (reviews.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outline),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.rate_review_outlined,
                                  size: 36, color: scheme.onSurfaceVariant),
                              const SizedBox(height: 8),
                              const Text('No reviews yet. Be the first!'),
                            ],
                          ),
                        ),
                      for (final r in reviews) _ReviewCard(review: r),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Small rounded label (year, genre).
class _InfoPill extends StatelessWidget {
  final String text;
  const _InfoPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline),
      ),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: scheme.onPrimaryContainer)),
    );
  }
}

// One user review: avatar, name, stars and comment.
class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initial =
        review.name.isEmpty ? '?' : review.name.substring(0, 1).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: scheme.primary,
            child: Text(initial,
                style: TextStyle(
                    color: scheme.onPrimary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(review.name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        i <= review.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 16,
                        color: const Color(0xFFD97706),
                      ),
                    const SizedBox(width: 6),
                    Text('${review.rating}/5',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
