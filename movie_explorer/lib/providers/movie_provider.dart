import 'package:flutter/material.dart';
import '../data/movies.dart';
import '../models/movie.dart';

// Holds all app state. Every method ends with notifyListeners()
// so the screens that use it rebuild automatically.
class MovieProvider extends ChangeNotifier {
  String query = '';
  String selectedGenre = 'All';
  bool isDark = false;

  final Set<int> _favorites = {};
  final Map<int, List<Review>> _reviews = {};

  // All genres for the filter chips.
  List<String> get genres => ['All', ...allMovies.map((m) => m.genre).toSet()];

  // Movies after applying search + genre filter.
  List<Movie> get filteredMovies => allMovies.where((m) {
        final genreOk = selectedGenre == 'All' || m.genre == selectedGenre;
        final searchOk = m.title.toLowerCase().contains(query.toLowerCase());
        return genreOk && searchOk;
      }).toList();

  // Top rated movies shown in the Trending row.
  List<Movie> get trending => allMovies.where((m) => m.rating >= 8.6).toList();

  List<Movie> get favoriteMovies =>
      allMovies.where((m) => _favorites.contains(m.id)).toList();

  bool isFavorite(int id) => _favorites.contains(id);

  List<Review> reviewsFor(int id) => _reviews[id] ?? [];

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setGenre(String genre) {
    selectedGenre = genre;
    notifyListeners();
  }

  void toggleFavorite(int id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void addReview(int id, Review review) {
    _reviews.putIfAbsent(id, () => []).insert(0, review);
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
