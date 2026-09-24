import 'package:flutter/material.dart';

import 'data.dart';
import 'info_row.dart';
import 'profile_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFFF7FF),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My profile'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ProfileHeader(name: myName, university: myUniversity),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (final fact in facts) ...[
                        InfoRow(label: fact.label, value: fact.value),
                        if (fact != facts.last) const Divider(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
