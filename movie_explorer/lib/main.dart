import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'screens/details_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/review_screen.dart';
import 'theme/app_theme.dart';

void main() {
  // ChangeNotifierProvider makes MovieProvider available to every screen.
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: const MovieExplorerApp(),
    ),
  );
}

class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<MovieProvider>().isDark;

    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      // Named routes
      routes: {
        '/': (context) => const HomeScreen(),
        '/details': (context) => const DetailsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/review': (context) => const ReviewScreen(),
      },
    );
  }
}
