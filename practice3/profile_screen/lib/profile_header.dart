import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/MyPhoto.png',
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              university,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
