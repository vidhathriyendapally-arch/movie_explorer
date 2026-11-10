import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/movies.dart';
import '../providers/movie_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_card.dart';

// StatefulWidget because the search box needs a TextEditingController.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: context.read<MovieProvider>().query);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // Responsive: number of grid columns depends on screen width.
  int columnsFor(double width) {
    if (width < 600) return 2; // mobile
    if (width < 800) return 3; // small tablet
    if (width < 1000) return 4; // tablet
    if (width < 1300) return 5; // laptop
    return 6; // large desktop
  }

  void _clearFilters(MovieProvider p) {
    _search.clear();
    p.setQuery('');
    p.setGenre('All');
  }

  // Gradient banner with the search bar.
  Widget _hero(MovieProvider p, bool narrow) {
    const dim = Color(0xFF475569);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(narrow ? 20 : 36),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(35),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover your next favourite movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: narrow ? 26 : 38,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search, filter by genre, save favourites and share your reviews.',
            style: TextStyle(
                color: Colors.white.withAlpha(215), fontSize: narrow ? 14 : 16),
          ),
          SizedBox(height: narrow ? 16 : 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: TextField(
              controller: _search,
              onChanged: p.setQuery,
              style: const TextStyle(color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search, color: dim),
                suffixIcon: p.query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close, color: dim),
                        onPressed: () {
                          _search.clear();
                          p.setQuery('');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                  icon: Icons.movie_outlined,
                  label: '${allMovies.length} movies'),
              _HeroPill(
                  icon: Icons.category_outlined,
                  label: '${p.genres.length - 1} genres'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MovieProvider>();
    final movies = p.filteredMovies;
    final trending = p.trending;
    final favCount = p.favoriteMovies.length;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.movie_filter_rounded,
                  size: 20, color: scheme.onPrimary),
            ),
            const SizedBox(width: 10),
            const Text('Movie Explorer'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: Badge(
              label: Text('$favCount'),
              isLabelVisible: favCount > 0,
              child: const Icon(Icons.favorite_border),
            ),
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
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 600;
          final pad = narrow ? 16.0 : 24.0;

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              // Keeps content readable on very wide screens.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _hero(p, narrow),
                      const SizedBox(height: 24),

                      // Genre chips
                      SizedBox(
                        height: 40,
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
                      const SizedBox(height: 28),

                      // Trending (horizontal list)
                      const _SectionHeader(
                        icon: Icons.local_fire_department_outlined,
                        title: 'Trending',
                        subtitle: 'Top rated picks',
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 262,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: trending.length,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: SizedBox(
                              width: 160,
                              child: MovieCard(movie: trending[i]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // All movies (grid)
                      _SectionHeader(
                        icon: Icons.grid_view_rounded,
                        title: 'All Movies',
                        subtitle: '${movies.length} titles',
                      ),
                      const SizedBox(height: 12),
                      if (movies.isEmpty)
                        _EmptyState(onClear: () => _clearFilters(p))
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movies.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columnsFor(constraints.maxWidth),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.66,
                          ),
                          itemBuilder: (context, i) => MovieCard(
                            movie: movies[i],
                            heroTag: 'poster_${movies[i].id}',
                          ),
                        ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Movie Explorer • Built with Flutter & Provider',
                          style: TextStyle(
                              fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                      ),
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

// Small translucent pill used inside the hero banner.
class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// Section title with an icon and a small note on the right.
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(subtitle, style: TextStyle(fontSize: 13, color: muted)),
      ],
    );
  }
}

// Shown when the search / genre filter finds nothing.
class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 52, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          const Text('No movies found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Try a different search or genre.',
              style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onClear, child: const Text('Clear filters')),
        ],
      ),
    );
  }
}
