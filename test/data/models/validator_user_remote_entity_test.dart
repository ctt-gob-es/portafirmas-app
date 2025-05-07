import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/validator_user_remote_entity.dart';

void main() {
  group('ValidatorUserRemoteEntity', () {
    test('should correctly serialize to JSON', () {
      const entity = ValidatorUserRemoteEntity(
        id: '123',
        dni: '45678901A',
        validatorUsername: 'JohnDoe',
      );

      final expectedJson = {
        'id': '123',
        'dni': '45678901A',
        '__cdata': 'JohnDoe',
      };

      final json = entity.toJson();
      expect(json, expectedJson);
    });

    test('should correctly deserialize from JSON', () {
      final json = {
        'id': '123',
        'dni': '45678901A',
        '__cdata': 'JohnDoe',
      };

      final entity = ValidatorUserRemoteEntity.fromJson(json);

      expect(entity.id, '123');
      expect(entity.dni, '45678901A');
      expect(entity.validatorUsername, 'JohnDoe');
    });

    test(
      'should throw error if required fields are missing during deserialization',
      () {
        final invalidJson = {
          'id': '123',
          'dni': '45678901A',
        };

        expect(
          () => ValidatorUserRemoteEntity.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
