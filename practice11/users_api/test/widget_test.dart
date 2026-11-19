import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:users_api/features/users/user.dart';

const _json = r'''
{"id":1,"name":"Leanne Graham","username":"Bret","email":"Sincere@april.biz",
"address":{"street":"Kulas Light","suite":"Apt. 556","city":"Gwenborough",
"zipcode":"92998-3874","geo":{"lat":"-37.3159","lng":"81.1496"}},
"phone":"1-770-736-8031 x56442","website":"hildegard.org",
"company":{"name":"Romaguera-Crona","catchPhrase":"Multi-layered client-server neural-net","bs":"harness real-time e-markets"}}
''';

void main() {
  test('User.fromJson / toJson round-trip', () {
    final user = User.fromJson(jsonDecode(_json) as Map<String, dynamic>);
    expect(user.address.geo.lat, -37.3159);
    expect(user.phoneDigits, '1770736803156442');
    expect(User.fromJson(user.toJson()), user);
  });

  test('wrong type of id throws TypeError', () {
    final map = jsonDecode(_json) as Map<String, dynamic>..['id'] = '1';
    expect(() => User.fromJson(map), throwsA(isA<TypeError>()));
  });
}
