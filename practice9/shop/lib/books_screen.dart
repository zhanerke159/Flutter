import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';
import 'cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
        ),
      ),
      body: ListView(
        children: filteredBooks.map((book) {
          return Builder(
            builder: (context) {
              final added = context.select<Cart, bool>(
                (cart) => cart.items.contains(book),
              );

              return ListTile(
                title: Text(book.title),
                subtitle: Text('${book.author} • ${book.price} ₸'),
                trailing: added
                    ? const Text('Added')
                    : OutlinedButton(
                        onPressed: () {
                          final ok = context.read<Cart>().add(book);

                          if (ok) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Added'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                          }
                        },
                        child: const Text('Add'),
                      ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
