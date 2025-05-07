import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/validate_petitions_list_remote_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'verifrp': {
      'r': [
        {'id': '1', 'ok': 'success'},
        {'id': '2', 'ok': 'failure'},
      ],
    },
  };

  group('ValidatePetitionsListRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final entity = ValidatePetitionsListRemoteEntity.fromJson(json);

      expect(entity.validatePetitions.length, 2);

      expect(entity.validatePetitions[0].id, '1');
      expect(entity.validatePetitions[0].status, 'success');
      expect(entity.validatePetitions[1].id, '2');
      expect(entity.validatePetitions[1].status, 'failure');
    });
  });
}
