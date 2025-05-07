import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/auth_data_remote_entity.dart';

void main() {
  group('AuthDataRemoteEntity', () {
    test('should parse fromJson correctly', () {
      final json = {
        'user': {'id': '1', 'dni': '12345678A', '__cdata': 'user123'},
        'authuser': {'id': '2', 'dni': '87654321B', '__cdata': 'authuser123'},
        'observations': {'__cdata': 'Some observation'},
        'id': '123',
        'type': 'type1',
        'state': 'state1',
        'startdate': '2024-01-01',
        'revdate': '2024-01-02',
        'sended': '2024-01-03',
      };

      final result = AuthDataRemoteEntity.fromJson(json);

      expect(result.user.id, '1');
      expect(result.authuser.id, '2');
      expect(result.observations?.observations, 'Some observation');
      expect(result.id, '123');
      expect(result.type, 'type1');
      expect(result.state, 'state1');
      expect(result.startdate, '2024-01-01');
      expect(result.revdate, '2024-01-02');
      expect(result.sended, '2024-01-03');
    });
  });
}
