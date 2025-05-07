import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/new_authorization_remote_entity.dart';

void main() {
  group('NewAuthorizationRemoteEntity', () {
    test('should correctly convert from JSON', () {
      final Map<String, dynamic> json = {
        'rqsaveauth': {
          'type': 'authorization',
          'authuser': {
            'dni': '12345678A',
            'id': 'authId123',
          },
          'startdate': {'\$t': '2024-12-01'},
          'expdate': '2025-12-01',
          'observations': {'\$t': 'Test observation'},
        },
      };

      final newAuthorization = NewAuthorizationRemoteEntity.fromJson(json);

      expect(newAuthorization.type, 'authorization');
      expect(newAuthorization.id, 'authId123');
      expect(newAuthorization.startDate, '2024-12-01');
      expect(newAuthorization.nif, '12345678A');
      expect(newAuthorization.expDate, '2025-12-01');
      expect(newAuthorization.observations, 'Test observation');
    });
  });
}
