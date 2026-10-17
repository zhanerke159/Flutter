import 'movie_category.dart';

class MovieEvent {
  final String title;
  final MovieCategory category;
  final DateTime when;
  final int limit;
  final List<String> _viewers;
  final bool online;
  final String place;
  final String? description;
  final bool favourite;

  const MovieEvent({
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required this.online,
    required this.place,
    required List<String> viewers,
    this.description,
    this.favourite = false,
  })
    // ignore: prefer_initializing_formals
    : _viewers = viewers;

  MovieEvent.empty()
    : title = '',
      category = MovieCategory.action,
      when = DateTime.now(),
      limit = 1,
      _viewers = const [],
      online = false,
      place = '',
      description = null,
      favourite = false;

  List<String> get viewers => List.unmodifiable(_viewers);

  int get count => _viewers.length;

  int get freePlaces => limit - count;

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) => _viewers.contains(name);

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  MovieEvent copyWith({
    String? title,
    MovieCategory? category,
    DateTime? when,
    int? limit,
    List<String>? viewers,
    bool? online,
    String? place,
    String? description,
    bool? favourite,
  }) {
    return MovieEvent(
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      viewers: viewers ?? _viewers,
      online: online ?? this.online,
      place: place ?? this.place,
      description: description ?? this.description,
      favourite: favourite ?? this.favourite,
    );
  }
}
