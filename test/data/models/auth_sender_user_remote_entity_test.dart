import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/auth_sender_user_remote_entity.dart';

void main() {
  group('AuthSenderUserRemoteEntity', () {
    test('should correctly convert from JSON', () {
      final Map<String, dynamic> json = {
        'id': 'user123',
        'dni': '12345678A',
        '__cdata': 'username123',
      };

      final authSenderUser = AuthSenderUserRemoteEntity.fromJson(json);

      expect(authSenderUser.id, 'user123');
      expect(authSenderUser.dni, '12345678A');
      expect(authSenderUser.username, 'username123');
    });
  });
}
