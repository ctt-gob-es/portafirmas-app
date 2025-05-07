import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_value_remote_entity.dart';

void main() {
  group('RevokeAuthResultValue', () {
    test('fromJson should correctly convert JSON to RevokeAuthResultValue', () {
      final json = {
        '\$t': 'Success',
      };

      final entity = RevokeAuthResultValue.fromJson(json);

      expect(entity.value, 'Success');
    });

    test('toJson should correctly convert RevokeAuthResultValue to JSON', () {
      const entity = RevokeAuthResultValue(value: 'Failed');

      final json = entity.toJson();

      expect(
        json['\$t'],
        'Failed',
      );
    });
  });
}
