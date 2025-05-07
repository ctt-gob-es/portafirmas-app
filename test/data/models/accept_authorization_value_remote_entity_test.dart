import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/accept_authorization_value_remote_entity.dart';

void main() {
  group('AcceptAuthResultValue', () {
    test('fromJson should return a valid AcceptAuthResultValue instance', () {
      final json = {
        '\$t': 'success',
      };

      final result = AcceptAuthResultValue.fromJson(json);

      expect(result, isA<AcceptAuthResultValue>());
      expect(result.value, 'success');
    });

    test('toJson should return a valid JSON representation', () {
      const entity = AcceptAuthResultValue(value: 'success');

      final json = entity.toJson();

      expect(json['\$t'], 'success');
    });
  });
}
