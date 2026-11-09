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
    final favs = p.favoriteMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet. Tap the heart on a movie!'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favs.length,
                  itemBuilder: (context, i) {
                    final m = favs[i];
                    return Card(
                      child: ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: PosterBox(movie: m)),
                        ),
                        title: Text(m.title),
                        subtitle: Text('${m.year} • ${m.genre}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBadge(rating: m.rating),
                            IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(Icons.delete),
                              onPressed: () => p.toggleFavorite(m.id),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(context, '/details',
                            arguments: m),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
