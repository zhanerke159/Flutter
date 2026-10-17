import 'package:flutter/material.dart';

import 'models/movie_event.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/shell_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = ThemeData().colorScheme.primary;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Club',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: seedColor)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      initialRoute: AppRoutes.shell,
      routes: {
        AppRoutes.shell: (context) =>
            ShellScreen(themeMode: _themeMode, onThemeChanged: _changeTheme),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.detail) {
          final args = settings.arguments as DetailArguments;

          return MaterialPageRoute(
            builder: (context) => DetailScreen(
              movie: args.movie,
              profile: args.profile,
              onMovieChanged: args.onMovieChanged,
              onMovieDeleted: args.onMovieDeleted,
              onOpenProfile: args.onOpenProfile,
            ),
          );
        }

        if (settings.name == AppRoutes.form) {
          final args = settings.arguments as FormArguments;

          return MaterialPageRoute<MovieEvent>(
            builder: (context) => FormScreen(movie: args.movie),
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Not found'))),
        );
      },
    );
  }
}
