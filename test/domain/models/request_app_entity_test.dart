import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/request_app_entity.dart';

void main() {
  group('RequestAppEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
        'id': '123',
        'name': 'Test App',
      };

      final requestAppEntity = RequestAppEntity.fromJson(json);

      expect(requestAppEntity.id, '123');
      expect(requestAppEntity.name, 'Test App');
    });
  });
}
