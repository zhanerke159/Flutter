import 'dart:convert';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
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
