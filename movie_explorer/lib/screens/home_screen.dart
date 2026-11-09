import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Responsive: number of grid columns depends on screen width.
  int columnsFor(double width) {
    if (width < 600) return 2; // mobile
    if (width < 800) return 3; // small tablet
    if (width < 1000) return 4; // tablet
    if (width < 1300) return 5; // laptop
    return 6; // large desktop
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MovieProvider>();
    final movies = p.filteredMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          // Dark mode toggle (icon changes with an animation).
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => p.toggleTheme(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(p.isDark ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(p.isDark)),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  onChanged: p.setQuery,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 12),

                // Genre chips
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final g in p.genres)
                        GenreChip(
                          label: g,
                          selected: p.selectedGenre == g,
                          onTap: () => p.setGenre(g),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Trending (horizontal list)
                const Text('Trending',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: p.trending.length,
                    itemBuilder: (context, i) => SizedBox(
                      width: 140,
                      child: MovieCard(movie: p.trending[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // All movies (grid)
                const Text('All Movies',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (movies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No movies found')),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movies.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsFor(constraints.maxWidth),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, i) => MovieCard(
                      movie: movies[i],
                      heroTag: 'poster_${movies[i].id}',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
