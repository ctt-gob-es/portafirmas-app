import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/revoke_requests_remote_entity.dart';

void main() {
  group('RevokeRequestsRemoteEntity', () {
    test('should parse JSON correctly', () {
      final Map<String, dynamic> json = {
        'rjcts': {
          'rjct': [
            {'id': '1', 'status': 'true'},
            {'id': '2', 'status': 'false'},
          ],
        },
      };

      final entity = RevokeRequestsRemoteEntity.fromJson(json);

      expect(entity.revokedRequests.length, 2);
      expect(entity.revokedRequests[0].id, '1');
      expect(entity.revokedRequests[0].status, 'true');
      expect(entity.revokedRequests[1].id, '2');
      expect(entity.revokedRequests[1].status, 'false');
    });

    test('should handle empty revokedRequests list', () {
      final Map<String, dynamic> json = {
        'rjcts': {'rjct': []},
      };

      final entity = RevokeRequestsRemoteEntity.fromJson(json);

      expect(entity.revokedRequests.isEmpty, true);
    });
  });
}
