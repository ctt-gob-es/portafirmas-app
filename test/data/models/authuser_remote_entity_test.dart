import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/authuser_remote_entity.dart';

void main() {
  group('AuthUserRemoteEntity', () {
    test('fromJson should return a valid AuthUserRemoteEntity instance', () {
      final json = {
        'id': '123',
        'dni': '98765432A',
        '__cdata': 'testuser',
      };

      final result = AuthUserRemoteEntity.fromJson(json);

      expect(result, isA<AuthUserRemoteEntity>());
      expect(result.id, '123');
      expect(result.dni, '98765432A');
      expect(result.authUsername, 'testuser');
    });

    test('toJson should return a valid JSON representation', () {
      const entity = AuthUserRemoteEntity(
        id: '123',
        dni: '98765432A',
        authUsername: 'testuser',
      );

      final json = entity.toJson();

      expect(json['id'], '123');
      expect(json['dni'], '98765432A');
      expect(json['__cdata'], 'testuser');
    });
  });
}
