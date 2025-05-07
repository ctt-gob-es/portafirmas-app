import 'package:portafirmas_app/data/models/remove_validator_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('RemoveUserRemoteEntity', () {
    test('fromJson maneja correctamente el JSON', () {
      final Map<String, dynamic> json = {
        'result': {
          '\$t': 'Some value',
        },
      };

      final result = RemoveUserRemoteEntity.fromJson(json);

      expect(result.result.value, 'Some value');
    });

    test('fromJson maneja correctamente un caso vacío', () {
      final Map<String, dynamic> json = {
        'result': {
          '\$t': 'Another value',
        },
      };

      final result = RemoveUserRemoteEntity.fromJson(json);

      expect(result.result.value, 'Another value');
    });
  });
}
