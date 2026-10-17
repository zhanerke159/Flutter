import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/movie_event.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  final MovieEvent movie;
  final Profile profile;
  final void Function(MovieEvent oldMovie, MovieEvent updatedMovie)
  onMovieChanged;
  final ValueChanged<MovieEvent> onMovieDeleted;
  final VoidCallback onOpenProfile;

  const DetailScreen({
    super.key,
    required this.movie,
    required this.profile,
    required this.onMovieChanged,
    required this.onMovieDeleted,
    required this.onOpenProfile,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late MovieEvent _movie;
  late Countdown _countdown;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _movie = widget.movie;
    _countdown = getCountdown(_movie.when);

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _countdown = getCountdown(_movie.when);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _countdownText() {
    return switch (_countdown) {
      Upcoming(:final duration) =>
        'Starts in ${duration.inDays}d '
            '${duration.inHours % 24}h '
            '${duration.inMinutes % 60}m',
      Started(:final duration) =>
        'Started ${duration.inHours}h '
            '${duration.inMinutes % 60}m ago',
      Ended() => 'Ended',
    };
  }

  Future<void> _editMovie() async {
    final oldMovie = _movie;

    final updatedMovie = await Navigator.pushNamed<MovieEvent>(
      context,
      AppRoutes.form,
      arguments: FormArguments(movie: _movie),
    );

    if (!mounted || updatedMovie == null) {
      return;
    }

    widget.onMovieChanged(oldMovie, updatedMovie);

    setState(() {
      _movie = updatedMovie;
      _countdown = getCountdown(_movie.when);
    });
  }

  Future<void> _changeRegistration() async {
    if (widget.profile.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete your profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              Navigator.pop(context);
              widget.onOpenProfile();
            },
          ),
        ),
      );

      return;
    }

    final isJoined = _movie.viewers.any((name) => name == widget.profile.name);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isJoined ? 'Leave screening?' : 'Join screening?'),
          content: Text(
            isJoined
                ? 'Do you want to leave this screening?'
                : 'Do you want to join this screening?',
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
              child: Text(isJoined ? 'Leave' : 'Join'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    final newViewers = isJoined
        ? _movie.viewers.where((name) => name != widget.profile.name).toList()
        : [..._movie.viewers, widget.profile.name];

    final oldMovie = _movie;

    final updatedMovie = _movie.copyWith(viewers: newViewers);

    widget.onMovieChanged(oldMovie, updatedMovie);

    setState(() {
      _movie = updatedMovie;
    });
  }

  Future<void> _deleteMovie() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete movie?'),
          content: Text('Do you want to delete "${_movie.title}"?'),
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    widget.onMovieDeleted(_movie);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final (:taken, :free) = _movie.places;

    final isJoined =
        widget.profile.name.isNotEmpty &&
        _movie.viewers.any((name) => name == widget.profile.name);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_movie.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editMovie();
                }

                if (value == 'delete') {
                  _deleteMovie();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ];
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: 'About'),
              Tab(text: 'Names (${_movie.count})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/movie_header.jpg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: CircleAvatar(child: Icon(_movie.category.icon)),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Chip(label: Text(_movie.category.label)),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_countdownText())),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _movie.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Date'),
                  subtitle: Text(formatDateTime(_movie.when)),
                ),
                ListTile(
                  leading: Icon(
                    _movie.online ? Icons.language : Icons.location_on,
                  ),
                  title: Text(_movie.online ? 'Online' : 'Place'),
                  subtitle: Text(_movie.place),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Places'),
                  subtitle: Text('$taken taken, $free free'),
                ),
                if (_movie.description != null)
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Description'),
                    subtitle: Text(_movie.description ?? ''),
                  ),
              ],
            ),
            _movie.viewers.isEmpty
                ? const EmptyState(
                    icon: Icons.people_outline,
                    message: 'Nobody is on the list yet',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _movie.viewers.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      final name = _movie.viewers[index];

                      final isYou =
                          widget.profile.name.isNotEmpty &&
                          name == widget.profile.name;

                      return ListTile(
                        leading: Icon(
                          isYou ? Icons.person : Icons.person_outline,
                        ),
                        title: Text(
                          isYou ? '$name (You)' : name,
                          style: isYou
                              ? Theme.of(context).textTheme.titleMedium
                              : null,
                        ),
                      );
                    },
                  ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: !isJoined && _movie.isFull
                  ? null
                  : _changeRegistration,
              child: Text(isJoined ? 'Leave' : 'Join'),
            ),
          ),
        ),
      ),
    );
  }
}
