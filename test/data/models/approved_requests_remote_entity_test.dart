import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/approved_request_remote_entity.dart';
import 'package:portafirmas_app/data/models/approved_requests_remote_entity.dart';

void main() {
  group('ApproveRequestsRemoteEntity', () {
    test('should parse fromJson correctly when apprq is a list', () {
      final json = {
        'apprq': {
          'r': [
            {'id': '1', 'ok': 'approved'},
            {'id': '2', 'ok': 'rejected'},
          ],
        },
      };

      final result = ApproveRequestsRemoteEntity.fromJson(json);

      expect(result.approvedRequest, isA<List<ApprovedRequestRemoteEntity>>());
      expect(result.approvedRequest.length, 2);
      expect(result.approvedRequest[0].id, '1');
      expect(result.approvedRequest[1].id, '2');
    });
  });
}
