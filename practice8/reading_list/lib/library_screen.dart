import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];

  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((book) => book.read).toList(),
  };

  Future<void> _openBook(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (context) => DetailScreen(book: book)),
    );

    if (!mounted) {
      return;
    }

    switch (action) {
      case null:
        break;

      case BookAction.toggleRead:
        setState(() {
          book.read = !book.read;
        });

      case BookAction.delete:
        setState(() {
          _books.remove(book);
        });
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );

    if (!mounted) {
      return;
    }

    if (book == null) {
      return;
    }

    setState(() {
      _books.add(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_books.length}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Books',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${totalPages(_books)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Pages',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${unread(_books).length}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Unread',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _filter == Filter.all,
                onSelected: (_) {
                  setState(() {
                    _filter = Filter.all;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Unread'),
                selected: _filter == Filter.unread,
                onSelected: (_) {
                  setState(() {
                    _filter = Filter.unread;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Read'),
                selected: _filter == Filter.read,
                onSelected: (_) {
                  setState(() {
                    _filter = Filter.read;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _visible.length,
              itemBuilder: (context, index) {
                final book = _visible[index];

                return BookTile(
                  book: book,
                  onToggle: () {
                    setState(() {
                      book.read = !book.read;
                    });
                  },
                  onTap: () {
                    _openBook(book);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
