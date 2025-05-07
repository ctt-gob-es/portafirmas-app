import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/post_sign_clave_remote_entity.dart';

void main() {
  group('PostSignClaveRemoteEntity', () {
    test('fromJson with valid data and no error', () {
      final json = {
        'cfsig': {'ok': 'true', 'ec': null, 'er': null},
      };

      final entity = PostSignClaveRemoteEntity.fromJson(json);

      expect(entity.status, true);
      expect(entity.error, isNull);
    });

    test('fromJson with valid data and an error', () {
      final json = {
        'cfsig': {'ok': 'false', 'ec': 'ErrorCode', 'er': null},
      };

      final entity = PostSignClaveRemoteEntity.fromJson(json);

      expect(entity.status, false);
      expect(entity.error, 'ErrorCode');
    });

    test('fromJson with alternative error field', () {
      final json = {
        'cfsig': {'ok': 'false', 'ec': null, 'er': 'ErrorMessage'},
      };

      final entity = PostSignClaveRemoteEntity.fromJson(json);

      expect(entity.status, false);
      expect(entity.error, 'ErrorMessage');
    });

    test('fromJson with unexpected ok value', () {
      final json = {
        'cfsig': {'ok': 'unexpected', 'ec': null, 'er': null},
      };

      final entity = PostSignClaveRemoteEntity.fromJson(json);

      expect(entity.status, false);
      expect(entity.error, isNull);
    });
  });
}
