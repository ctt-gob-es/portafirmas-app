import 'package:portafirmas_app/data/models/pre_sign_clave_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('PreSignClaveRemoteEntity Tests', () {
    test('should create PreSignClaveRemoteEntity from valid JSON', () {
      final json = {
        'cfrqt': {
          'ok': 'true',
          '__cdata': 'https://example.com/sign',
        },
      };

      final result = PreSignClaveRemoteEntity.fromJson(json);

      expect(result.status, true);
      expect(result.signUrl, 'https://example.com/sign');
    });

    test('should handle "ok" being false in JSON', () {
      final json = {
        'cfrqt': {
          'ok': 'false',
          '__cdata': 'https://example.com/sign',
        },
      };

      final result = PreSignClaveRemoteEntity.fromJson(json);

      expect(result.status, false);
      expect(result.signUrl, 'https://example.com/sign');
    });

    test('should throw an error when "__cdata" field is missing', () {
      final json = {
        'cfrqt': {
          'ok': 'true',
        },
      };

      expect(
        () => PreSignClaveRemoteEntity.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
