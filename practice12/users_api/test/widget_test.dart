import 'package:flutter_test/flutter_test.dart';
import 'package:users_api/features/users/user.dart';

void main() {
  const json = {
    'id': 1,
    'name': 'Leanne Graham',
    'username': 'Bret',
    'email': 'Sincere@april.biz',
    'phone': '1-770-736-8031 x56442',
    'website': 'hildegard.org',
    'address': {
      'street': 'Kulas Light',
      'suite': 'Apt. 556',
      'city': 'Gwenborough',
      'zipcode': '92998-3874',
      'geo': {'lat': '-37.3159', 'lng': '81.1496'},
    },
    'company': {'name': 'Romaguera-Crona', 'catchPhrase': 'Multi-layered'},
  };

  test('User survives the JSON round trip used by UsersCache', () {
    final user = User.fromJson(json);
    final again = User.fromJson(user.toJson());

    expect(again.id, 1);
    expect(again.address.city, 'Gwenborough');
    expect(again.company.name, 'Romaguera-Crona');
  });

  test('phoneDigits keeps digits and drops the extension', () {
    expect(User.fromJson(json).phoneDigits, '17707368031');
  });
}
