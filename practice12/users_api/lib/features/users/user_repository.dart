import 'dart:convert';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_cache.dart';

typedef UsersResult = ({List<User> items, bool fromCache});

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<List<User>> _fetch() async {
    final data = await _api.get(Uri.https(_api.host, '/users'));

    try {
      return (data as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<UsersResult> getAll() async {
    try {
      final fresh = await _fetch();
      await _cache.save(fresh);
      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow; // honest Offline screen
      return (items: saved, fromCache: true);
    }
  }

  Future<User> getById(int id) async {
    final data = await _api.get(Uri.https(_api.host, '/users/$id'));

    try {
      return User.fromJson(data as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    final data = await _api.post(
      Uri.https(_api.host, '/users'),
      body: jsonEncode(draft.toJson()),
      additionalHeaders: {'Content-Type': 'application/json'},
    );

    try {
      return User.fromJson(data as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users: $e');
    }
  }
}
