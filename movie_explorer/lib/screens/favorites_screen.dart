import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/poster_box.dart';
import '../widgets/rating_badge.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MovieProvider>();
    final scheme = Theme.of(context).colorScheme;
    final favs = p.favoriteMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 64, color: scheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    const Text(
                      'No favorites yet. Tap the heart on a movie!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false),
                      icon: const Icon(Icons.movie_outlined),
                      label: const Text('Browse movies'),
                    ),
                  ],
                ),
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${favs.length} saved ${favs.length == 1 ? 'movie' : 'movies'}',
                          style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    // 1 column on mobile, 2 on wide screens.
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favs.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 560,
                          mainAxisExtent: 108,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, i) {
                          final m = favs[i];
                          return Material(
                            color: scheme.surface,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: scheme.outline),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, '/details',
                                  arguments: m),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 84,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            PosterBox(movie: m, compact: true),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(m.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16)),
                                          const SizedBox(height: 2),
                                          Text('${m.year} • ${m.genre}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      scheme.onSurfaceVariant)),
                                          const SizedBox(height: 8),
                                          RatingBadge(rating: m.rating),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Remove',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => p.toggleFavorite(m.id),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
