import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/login_clave_remote_entity.dart';
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';

void main() {
  group('LoginClaveRemoteEntityExtension', () {
    test('should convert LoginClaveRemoteEntity to LoginClaveEntity', () {
      const remoteEntity = LoginClaveRemoteEntity(
        url: 'https://example.com',
        cookies: {'session': '123456', 'user': 'testuser'},
      );

      final entity = remoteEntity.toLoginClaveEntity();

      expect(entity.url, 'https://example.com');
      expect(entity.cookies, {'session': '123456', 'user': 'testuser'});
    });
  });
}
