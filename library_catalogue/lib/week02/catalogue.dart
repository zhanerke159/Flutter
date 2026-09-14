import 'models.dart';

class Library {
  final List<LibraryItem> items;
  Library(this.items);

  late final DateTime openedAt;
  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  void open() {
    openedAt = DateTime.now();
  }

  String buildReport() {
    return _cachedReport ??= 'Library contains ${items.length} items.';
  }

  // Level 4
  List<String> get everyTitle => items.map((item) => item.title).toList();

  List<Book> get oldyBooks =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  // fold is used instead of reduce because reduce cannot work with an empty list.
  double get avgPage =>
      items.whereType<Book>().fold<int>(0, (sum, book) => sum + book.pages) /
      items.whereType<Book>().length;

  Map<String, int> get booksByAuthor =>
      items.whereType<Book>().fold<Map<String, int>>({}, (count, book) {
        count[book.author.name] = (count[book.author.name] ?? 0) + 1;
        return count;
      });

  Set<String> get authorName =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  Set<Genre> get genreName =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  List<String> get displayList => [
    'CATALOGUE',
    for (final book in items.whereType<Book>()) '${book.title} (${book.year})',
    ...authorName,
    if (items.whereType<Book>().any((book) => book.pages == 0))
      '(incomplete data)',
  ];
}
