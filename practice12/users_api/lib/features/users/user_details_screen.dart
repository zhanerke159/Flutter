import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';
import 'user.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.user});

  final User user;

  /// launchUrl returns false when no app can open the link.
  Future<void> _open(BuildContext context, Uri uri) async {
    var ok = false;
    try {
      ok = await launchUrl(uri);
    } on PlatformException {
      ok = false;
    }
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  // Debug only: proves the header exists without ever printing the token.
  Future<void> _copyToken(BuildContext context) async {
    final store = context.read<SecureStore>();
    final token = await store.readToken();
    if (token == null) return;
    await Clipboard.setData(ClipboardData(text: token));
  }

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
            _buildRow(
              'Email',
              user.email,
              onTap: () =>
                  _open(context, Uri(scheme: 'mailto', path: user.email)),
            ),
            _buildRow(
              'Phone',
              user.phone,
              onTap: () =>
                  _open(context, Uri(scheme: 'tel', path: user.phoneDigits)),
            ),
            _buildRow(
              'Website',
              user.website ?? 'Not available',
              onTap: switch (user.website) {
                final site? => () => _open(context, Uri.parse('https://$site')),
                null => null,
              },
            ),
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
          if (kDebugMode)
            OutlinedButton.icon(
              icon: const Icon(Icons.bug_report),
              label: const Text('Copy token to clipboard'),
              onPressed: () => _copyToken(context),
            ),
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

  Widget _buildRow(String label, String value, {VoidCallback? onTap}) {
    final row = Padding(
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
          Expanded(
            child: Text(
              value,
              style: onTap == null
                  ? null
                  : const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
            ),
          ),
        ],
      ),
    );

    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }
}
