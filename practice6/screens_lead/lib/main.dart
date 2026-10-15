import 'package:flutter/material.dart';

import 'students_screen.dart';
import 'routes.dart';
import 'students.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    initialRoute: Routes.students,
    routes: {Routes.students: (_) => const StudentsScreen()},
    onGenerateRoute: (settings) {
      final name = settings.name;
      final student = settings.arguments;

      if (name == Routes.student && student is Student) {
        return MaterialPageRoute<void>(
          builder: (_) => DetailScreen(student: student),
        );
      }

      if (name == Routes.edit && student is Student) {
        return MaterialPageRoute<String>(
          builder: (_) => EditScreen(student: student),
        );
      }

      return null;
    },
  );
}
