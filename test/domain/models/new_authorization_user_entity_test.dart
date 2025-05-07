import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/new_authorization_remote_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';

void main() {
  group('NewAuthorizationUserEntity', () {
    test('should create a NewAuthorizationUserEntity with required fields', () {
      final entity = NewAuthorizationUserEntity(
        type: 'type-example',
        nif: '12345678A',
        id: 'user-id',
        observations: 'Some observations',
        startDate: '2024-01-01',
        expDate: '2024-12-31',
      );

      expect(entity.type, 'type-example');
      expect(entity.nif, '12345678A');
      expect(entity.id, 'user-id');
      expect(entity.observations, 'Some observations');
      expect(entity.startDate, '2024-01-01');
      expect(entity.expDate, '2024-12-31');
    });

    test(
      'should convert NewAuthorizationRemoteEntity to NewAuthorizationUserEntity',
      () {
        const remoteEntity = NewAuthorizationRemoteEntity(
          type: 'remote-type',
          nif: '87654321B',
          id: 'remote-id',
          observations: 'Remote observations',
          startDate: '2023-01-01',
          expDate: '2023-12-31',
        );

        final userEntity = remoteEntity.toValidatorUserEntity();

        expect(userEntity.type, 'remote-type');
        expect(userEntity.nif, '87654321B');
        expect(userEntity.id, 'remote-id');
        expect(userEntity.observations, 'Remote observations');
        expect(userEntity.startDate, '2023-01-01');
        expect(userEntity.expDate, '2023-12-31');
      },
    );
  });
}
