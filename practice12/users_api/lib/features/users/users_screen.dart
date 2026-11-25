import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';
import 'new_user_screen.dart';
import 'user_details_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    final city = context.select<SettingsModel, String?>((s) => s.city);
    final visible = m.visible(city);
    final error = m.error;

    Widget body;
    if (m.loading && m.items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null && m.items.isEmpty) {
      body = _ErrorView(error: error, onRetry: m.load);
    } else {
      body = Column(
        children: [
          // Only when the data really comes from the cache.
          if (m.fromCache)
            MaterialBanner(
              content: const Text('Saved data · no connection'),
              leading: const Icon(Icons.cloud_off),
              actions: [
                TextButton(onPressed: m.load, child: const Text('Retry')),
              ],
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: m.load,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: visible.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = visible[index];

                  return ListTile(
                    leading: CircleAvatar(child: Text(user.id.toString())),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\n${user.address.city}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => UserDetailsScreen(user: user),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'New user',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, text) = switch (error) {
      NoConnectionException() => (
        Icons.wifi_off,
        'Offline and nothing saved yet',
      ),
      ServerException(:final status) => (
        Icons.error_outline,
        'Server error: $status',
      ),
      NotFoundException() ||
      UnauthorizedException() => (Icons.error_outline, 'Request failed'),
      BadResponseException() => (
        Icons.error_outline,
        'Invalid response from server',
      ),
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60),
          const SizedBox(height: 16),
          Text(text),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
