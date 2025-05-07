import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_value_remote_entity.dart';

void main() {
  group('RevokeAuthRemoteEntity', () {
    test('should correctly serialize and deserialize from JSON', () {
      final Map<String, dynamic> json = {
        'result': {
          '\$t': 'Success',
        },
      };

      const revokeAuthResultValue = RevokeAuthResultValue(value: 'Success');
      const revokeAuthRemoteEntity =
          RevokeAuthRemoteEntity(result: revokeAuthResultValue);

      final entityFromJson = RevokeAuthRemoteEntity.fromJson(json);

      expect(entityFromJson, isA<RevokeAuthRemoteEntity>());
      expect(entityFromJson.result.value, 'Success');

      final jsonFromEntity = revokeAuthRemoteEntity.toJson();

      expect(jsonFromEntity.length, 1);
    });

    test('should throw error if JSON is invalid', () {
      final invalidJson = {
        '\$t': 'Success',
      };

      expect(
        () => RevokeAuthRemoteEntity.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
