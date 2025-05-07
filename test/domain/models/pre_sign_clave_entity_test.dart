import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/pre_sign_clave_entity.dart';

void main() {
  group('PreSignClaveEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
        'status': true,
        'signUrl': 'https://example.com/sign-url',
      };

      final preSignClaveEntity = PreSignClaveEntity.fromJson(json);

      expect(preSignClaveEntity.status, true);
      expect(preSignClaveEntity.signUrl, 'https://example.com/sign-url');
    });
  });
}
