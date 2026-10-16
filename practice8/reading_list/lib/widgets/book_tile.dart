import 'package:flutter/material.dart';

import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(child: Text(book.title[0])),
                  if (!book.read)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${book.author} · ${book.pages} pp.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: book.read,
                onChanged: (_) {
                  onToggle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
