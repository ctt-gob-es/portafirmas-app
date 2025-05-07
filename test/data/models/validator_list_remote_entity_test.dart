import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/validator_list_remote_entity.dart';

void main() {
  group('ValidatorRemoteEntity', () {
    test('should correctly deserialize from JSON', () {
      final json = {
        'user': {
          'id': '123',
          'dni': '45678901A',
          '__cdata': 'JohnDoe',
        },
        'forapps': 'AppName',
      };

      final entity = ValidatorRemoteEntity.fromJson(json);

      expect(entity.validatorUser.id, '123');
      expect(entity.validatorUser.dni, '45678901A');
      expect(entity.validatorUser.validatorUsername, 'JohnDoe');
      expect(entity.forapps, 'AppName');
    });

    test(
      'should throw an error if required fields are missing during deserialization',
      () {
        final invalidJson = {
          'user': {
            'id': '123',
            'dni': '45678901A',
          },
        };

        expect(
          () => ValidatorRemoteEntity.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
