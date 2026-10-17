import 'package:flutter/material.dart';

import '../models/movie_category.dart';
import '../models/movie_event.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  final List<MovieEvent> movies;
  final Profile profile;
  final void Function(MovieEvent oldMovie, MovieEvent updatedMovie)
  onMovieChanged;
  final ValueChanged<MovieEvent> onMovieAdded;
  final ValueChanged<MovieEvent> onMovieDeleted;
  final VoidCallback onOpenProfile;

  const MoviesScreen({
    super.key,
    required this.movies,
    required this.profile,
    required this.onMovieChanged,
    required this.onMovieAdded,
    required this.onMovieDeleted,
    required this.onOpenProfile,
  });

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _search = '';
  MovieCategory? _selectedCategory;
  bool _showPast = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = widget.movies
        .where((movie) {
          final matchesSearch = movie.title.toLowerCase().contains(
            _search.toLowerCase(),
          );

          final matchesCategory =
              _selectedCategory == null || movie.category == _selectedCategory;

          final matchesPast = _showPast || !movie.isPast;

          return matchesSearch && matchesCategory && matchesPast;
        })
        .map((movie) => movie)
        .toList();

    visibleMovies.sort((first, second) => first.when.compareTo(second.when));

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movies',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _search = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                for (final category in MovieCategory.values) ...[
                  ChoiceChip(
                    avatar: Icon(category.icon),
                    label: Text(category.label),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Show past'),
                avatar: const Icon(Icons.history),
                selected: _showPast,
                onSelected: (selected) {
                  setState(() {
                    _showPast = selected;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: visibleMovies.isEmpty
                ? const EmptyState(
                    icon: Icons.movie_filter_outlined,
                    message: 'No movies found',
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        final columnCount = (constraints.maxWidth / 360).ceil();

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columnCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.6,
                              ),
                          itemCount: visibleMovies.length,
                          itemBuilder: (context, index) {
                            return _buildMovieCard(visibleMovies[index]);
                          },
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: visibleMovies.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        itemBuilder: (context, index) {
                          return _buildMovieCard(visibleMovies[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final movie = await Navigator.pushNamed<MovieEvent>(
            context,
            AppRoutes.form,
            arguments: const FormArguments(),
          );

          if (!mounted || movie == null) {
            return;
          }

          widget.onMovieAdded(movie);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMovieCard(MovieEvent movie) {
    return MovieCard(
      movie: movie,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detail,
          arguments: DetailArguments(
            movie: movie,
            profile: widget.profile,
            onMovieChanged: widget.onMovieChanged,
            onMovieDeleted: widget.onMovieDeleted,
            onOpenProfile: widget.onOpenProfile,
          ),
        );
      },
      onFavourite: () {
        final updatedMovie = movie.copyWith(favourite: !movie.favourite);

        widget.onMovieChanged(movie, updatedMovie);
      },
    );
  }
}
