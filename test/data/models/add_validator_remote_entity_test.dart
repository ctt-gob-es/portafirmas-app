import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/add_validator_remote_entity.dart';

void main() {
  group('AddUserRemoteEntity', () {
    test('fromJson should correctly convert JSON to AddUserRemoteEntity', () {
      final json = {
        'result': {'\$t': 'Success'},
      };

      final entity = AddUserRemoteEntity.fromJson(json);

      expect(entity.result.value, 'Success');
    });
  });
}
