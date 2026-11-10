import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'screens/app_shell.dart';
import 'screens/details_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/review_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: const MovieExplorerApp(),
    ),
  );
}

// Lets horizontal lists be dragged with a mouse on web.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

// Shows Login until the user logs in (or continues as guest), then the app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.select<MovieProvider, bool>((p) => p.isLoggedIn);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: loggedIn
          ? const AppShell(key: ValueKey('app'))
          : const LoginScreen(key: ValueKey('login')),
    );
  }
}

class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<MovieProvider>().isDark;

    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      // Named routes (opened with Navigator.pushNamed).
      routes: {
        '/details': (context) => const DetailsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/review': (context) => const ReviewScreen(),
      },
      // Always start at the AuthGate, even after a browser refresh on
      // /details or /review (those pages need a movie passed to them).
      onGenerateInitialRoutes: (String initialRoute) => [
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/'),
          builder: (context) => const AuthGate(),
        ),
      ],
    );
  }
}