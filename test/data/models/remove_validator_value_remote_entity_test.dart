import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/remove_validator_value_remote_entity.dart';

void main() {
  group('RemoveValidatorResultValue', () {
    test('fromJson should return a valid instance from JSON', () {
      final json = {
        '\$t': 'SomeValue',
      };

      final result = RemoveValidatorResultValue.fromJson(json);

      expect(result, isA<RemoveValidatorResultValue>());
      expect(result.value, 'SomeValue');
    });

    test('toJson should return a valid JSON representation', () {
      const value = RemoveValidatorResultValue(value: 'SomeValue');
      final json = value.toJson();

      expect(json['\$t'], 'SomeValue');
    });

    test('should create a valid RemoveValidatorResultValue instance', () {
      const value = RemoveValidatorResultValue(value: 'SomeValue');

      expect(value.value, 'SomeValue');
    });
  });
}
