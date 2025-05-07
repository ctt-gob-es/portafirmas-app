import 'package:portafirmas_app/data/models/post_sign_req_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostSignReqRemoteEntity Tests', () {
    test('should create PostSignReqRemoteEntity from JSON', () {
      final json = {
        'id': '12345',
        'status': 'OK',
      };

      final result = PostSignReqRemoteEntity.fromJson(json);

      expect(result.requestId, '12345');
      expect(result.status, true);
    });

    test('should handle status as KO', () {
      final json = {
        'id': '67890',
        'status': 'KO',
      };

      final result = PostSignReqRemoteEntity.fromJson(json);

      expect(result.requestId, '67890');
      expect(result.status, false);
    });
  });
}
