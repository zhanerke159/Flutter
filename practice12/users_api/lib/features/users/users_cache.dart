import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

class UsersCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory(); // never Temporary
    return File('${dir.path}/users.json');
  }

  Future<void> save(List<User> list) async {
    final f = await _file();
    await f.writeAsString(jsonEncode([for (final u in list) u.toJson()]));
  }

  /// null = nothing saved (or the file is unreadable).
  Future<List<User>?> load() async {
    final f = await _file();
    if (!await f.exists()) return null;
    try {
      final raw = jsonDecode(await f.readAsString()) as List<dynamic>;
      return [for (final m in raw) User.fromJson(m as Map<String, dynamic>)];
    } on FormatException {
      return null;
    } on TypeError {
      return null; // file has an old / broken shape
    }
  }
}
