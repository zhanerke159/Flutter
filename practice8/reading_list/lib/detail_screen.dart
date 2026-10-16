import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${book.title}'),
            Text('Author: ${book.author}'),
            Text('Pages: ${book.pages}'),
            Text(book.year == null ? 'Year unknown' : 'Year: ${book.year}'),
            Text(book.read ? 'Read: Yes' : 'Read: No'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(BookAction.toggleRead);
              },
              child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
            ),
            FilledButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text("Delete '${book.title}'?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (!context.mounted) {
                  return;
                }

                if (result == true) {
                  Navigator.of(context).pop(BookAction.delete);
                }
              },
              child: const Text('Delete'),
            ),  
          ],
        ),
      ),
    );
  }
}
