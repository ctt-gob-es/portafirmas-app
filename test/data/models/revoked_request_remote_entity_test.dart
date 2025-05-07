import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/revoked_request_remote_entity.dart';

void main() {
  group('RevokedRequestRemoteEntity', () {
    test('fromJson should return a valid instance from JSON', () {
      final json = {
        'id': '123',
        'status': 'OK',
      };

      final revokedRequest = RevokedRequestRemoteEntity.fromJson(json);

      expect(revokedRequest, isA<RevokedRequestRemoteEntity>());
      expect(revokedRequest.id, '123');
      expect(revokedRequest.status, 'OK');
    });

    test('should create a valid RevokedRequestRemoteEntity instance', () {
      const revokedRequest =
          RevokedRequestRemoteEntity(id: '123', status: 'OK');

      expect(revokedRequest.id, '123');
      expect(revokedRequest.status, 'OK');
    });
  });
}
