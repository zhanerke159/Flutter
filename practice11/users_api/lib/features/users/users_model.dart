import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repository);

  final UserRepository _repository;

  List<User> items = const [];
  bool loading = false;
  ApiException? error;
  bool saving = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await _repository.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<User> createUser(User draft) async {
    saving = true;
    notifyListeners();

    try {
      final user = await _repository.create(draft);

      items = [user, ...items];

      return user;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
