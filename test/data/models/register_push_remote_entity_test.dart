import 'package:portafirmas_app/data/models/register_push_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('RegisterPushRemoteEntity Tests', () {
    test('should create RegisterPushRemoteEntity from JSON', () {
      final json = {
        'reg': {'ok': 'true'},
      };

      final result = RegisterPushRemoteEntity.fromJson(json);

      expect(result.status, 'true');
    });
  });
}
