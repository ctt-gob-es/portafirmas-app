import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/post_sign_remote_entity.dart';

void main() {
  group('PostSignRemoteEntity', () {
    test('fromJson with multiple signed requests', () {
      final json = {
        'req': [
          {'id': '123', 'status': 'OK'},
          {'id': '456', 'status': 'KO'},
        ],
      };

      final entity = PostSignRemoteEntity.fromJson(json);

      expect(entity.signedRequests.length, 2);
      expect(entity.signedRequests[0].requestId, '123');
      expect(entity.signedRequests[0].status, true);
      expect(entity.signedRequests[1].requestId, '456');
      expect(entity.signedRequests[1].status, false);
    });

    test('fromJson with a single signed request', () {
      final json = {
        'req': {'id': '789', 'status': 'OK'},
      };

      final entity = PostSignRemoteEntity.fromJson(json);

      expect(entity.signedRequests.length, 1);
      expect(entity.signedRequests[0].requestId, '789');
      expect(entity.signedRequests[0].status, true);
    });
  });
}
