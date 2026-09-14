// ignore_for_file: avoid_print
import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final books = rawBooks.map((json) => Book.fromJson(json)).toList();

  final library = Library(books);

  print('Every title: ${library.everyTitle}');
  print('Books after 2010: ${library.oldyBooks}');
  print('Average page count: ${library.avgPage}');
  print('Books by author: ${library.booksByAuthor}');
  print('Author names: ${library.authorName}');
  print('Genres: ${library.genreName}');

  final stats = statsOf(books);
  print('Book count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  final empty = Empty();
  final ready = Ready(books);
  final broken = Broken('Catalogue is unavailable.');

  print(describe(empty));
  print(describe(ready));
  print(describe(broken));
}
