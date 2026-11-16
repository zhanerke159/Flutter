import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              user.id.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),

          _buildSection('Personal information', [
            _buildRow('Name', user.name),
            _buildRow('Username', user.username),
            _buildRow('Email', user.email),
            _buildRow('Phone', user.phone),
            _buildRow('Website', user.website ?? 'Not available'),
          ]),

          _buildSection('Address', [
            _buildRow('Street', user.address.street),
            _buildRow('Suite', user.address.suite),
            _buildRow('City', user.address.city),
            _buildRow('Zipcode', user.address.zipcode),
            _buildRow('Latitude', user.address.geo.lat.toString()),
            _buildRow('Longitude', user.address.geo.lng.toString()),
          ]),

          _buildSection('Company', [
            _buildRow('Name', user.company.name),
            _buildRow('Catch phrase', user.company.catchPhrase),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
