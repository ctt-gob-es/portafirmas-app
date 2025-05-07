import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/post_sign_clave_entity.dart';

void main() {
  group('PostSignClaveEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
        'status': true,
        'error': 'Some error message',
      };

      final postSignClaveEntity = PostSignClaveEntity.fromJson(json);

      expect(postSignClaveEntity.status, true);
      expect(postSignClaveEntity.error, 'Some error message');
    });

    test('should handle missing error correctly', () {
      final json = {
        'status': false,
      };

      final postSignClaveEntity = PostSignClaveEntity.fromJson(json);

      expect(postSignClaveEntity.status, false);
      expect(postSignClaveEntity.error, isNull);
    });
  });
}
