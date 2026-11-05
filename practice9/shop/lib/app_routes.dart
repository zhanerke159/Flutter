import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'cart_screen.dart';

class AppRoutes {
  static const String books = '/';
  static const String cart = '/cart';

  static final Map<String, WidgetBuilder> routes = {
    books: (context) => const BooksScreen(),
    cart: (context) => const CartScreen(),
  };
}