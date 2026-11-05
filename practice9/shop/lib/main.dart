import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'app_routes.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()));
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Shop',
      initialRoute: AppRoutes.books,
      routes: AppRoutes.routes,
    );
  }
}
