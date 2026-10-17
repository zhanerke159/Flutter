import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/movie_event.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/movie_card.dart';
import 'movies_screen.dart';
import 'profile_screen.dart';

class ShellScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ShellScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;

  late List<MovieEvent> _movies;
  Profile _profile = const Profile.empty();

  @override
  void initState() {
    super.initState();
    _movies = createSeedMovies();
  }

  void _addMovie(MovieEvent movie) {
    setState(() {
      _movies = [..._movies, movie];
    });
  }

  void _updateMovie(MovieEvent oldMovie, MovieEvent updatedMovie) {
    setState(() {
      _movies = [
        for (final movie in _movies)
          if (identical(movie, oldMovie)) updatedMovie else movie,
      ];
    });
  }

  void _deleteMovie(MovieEvent movieToDelete) {
    setState(() {
      _movies = _movies
          .where((movie) => !identical(movie, movieToDelete))
          .toList();
    });
  }

  void _updateProfile(Profile profile) {
    setState(() {
      _profile = profile;
    });
  }

  void _openProfile() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _showAbout() {
    final totalViewers = _movies.fold<int>(
      0,
      (total, movie) => total + movie.count,
    );

    showAboutDialog(
      context: context,
      applicationName: 'Movie Club',
      applicationVersion: '1.0',
      children: [
        const Text('Flutter application for managing movie screenings.'),
        const SizedBox(height: 8),
        Text('Total registrations: $totalViewers'),
      ],
    );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset data?'),
          content: const Text(
            'All changes will be removed and the original data will be restored.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _movies = createSeedMovies();
      _profile = const Profile.empty();
    });
  }

  void _openDetail(MovieEvent movie) {
    Navigator.pushNamed(
      context,
      AppRoutes.detail,
      arguments: DetailArguments(
        movie: movie,
        profile: _profile,
        onMovieChanged: _updateMovie,
        onMovieDeleted: _deleteMovie,
        onOpenProfile: _openProfile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Club')),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.movie),
                title: Text('Movie Club'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  _showAbout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset data'),
                onTap: () {
                  Navigator.pop(context);
                  _resetData();
                },
              ),
            ],
          ),
        ),
      ),
      body: switch (_selectedIndex) {
        0 => _buildMoviesTab(),
        1 => _buildFavouritesTab(),
        2 => _buildProfileTab(),
        _ => const SizedBox.shrink(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesTab() {
    return MoviesScreen(
      movies: _movies,
      profile: _profile,
      onMovieChanged: _updateMovie,
      onMovieAdded: _addMovie,
      onMovieDeleted: _deleteMovie,
      onOpenProfile: _openProfile,
    );
  }

  Widget _buildFavouritesTab() {
    final favourites = _movies.where((movie) => movie.favourite).toList();

    if (favourites.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        message: 'No favourite movies yet',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          final columnCount = (constraints.maxWidth / 360).ceil();

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.6,
            ),
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final movie = favourites[index];

              return MovieCard(
                movie: movie,
                onTap: () {
                  _openDetail(movie);
                },
                onFavourite: () {
                  final updatedMovie = movie.copyWith(
                    favourite: !movie.favourite,
                  );

                  _updateMovie(movie, updatedMovie);
                },
              );
            },
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: favourites.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
          itemBuilder: (context, index) {
            final movie = favourites[index];

            return MovieCard(
              movie: movie,
              onTap: () {
                _openDetail(movie);
              },
              onFavourite: () {
                final updatedMovie = movie.copyWith(
                  favourite: !movie.favourite,
                );

                _updateMovie(movie, updatedMovie);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return ProfileScreen(
      profile: _profile,
      movies: _movies,
      themeMode: widget.themeMode,
      onProfileChanged: _updateProfile,
      onThemeChanged: widget.onThemeChanged,
    );
  }
}
