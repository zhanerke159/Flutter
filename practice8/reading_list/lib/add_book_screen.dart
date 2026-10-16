import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _pages.dispose();
    _year.dispose();

    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        pages: int.parse(_pages.text),
        year: int.tryParse(_year.text),
      );

      Navigator.of(context).pop(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  if ((value ?? '').trim().length < 2) {
                    return 'Title must be at least 2 characters';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(labelText: 'Author'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Author is required';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _pages,
                decoration: const InputDecoration(labelText: 'Pages'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  final n = int.tryParse(value ?? '');

                  if (n == null || n <= 0) {
                    return 'A whole number above 0';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _year,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onFieldSubmitted: (_) {
                  _save();
                },
                validator: (value) {
                  final text = (value ?? '').trim();

                  if (text.isEmpty) {
                    return null;
                  }

                  final year = int.tryParse(text);

                  if (year == null ||
                      year < 1450 ||
                      year > DateTime.now().year) {
                    return 'Enter a year between 1450 and ${DateTime.now().year}';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
