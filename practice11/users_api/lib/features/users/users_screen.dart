import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'users_model.dart';
import 'user_details_screen.dart';
import 'new_user_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'New user',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewUserScreen()),
              );
            },
          ),
        ],
      ),
      body: m.loading && m.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : switch (m.error) {
              null => RefreshIndicator(
                onRefresh: m.load,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: m.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = m.items[index];

                    return ListTile(
                      leading: CircleAvatar(child: Text(user.id.toString())),
                      title: Text(user.name),
                      subtitle: Text('${user.email}\n${user.address.city}'),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(user: user),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              NoConnectionException() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 60),
                    const SizedBox(height: 16),
                    const Text('No internet connection'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: m.load,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              NotFoundException() || UnauthorizedException() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Request failed'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: m.load,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              ServerException(:final status) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Server error: $status'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: m.load,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              BadResponseException() => const Center(
                child: Text('Invalid response from server'),
              ),
            },
    );
  }
}
