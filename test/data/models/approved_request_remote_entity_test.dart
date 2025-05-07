import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/approved_request_remote_entity.dart';

void main() {
  group('ApprovedRequestRemoteEntity', () {
    test('should correctly convert from JSON', () {
      final Map<String, dynamic> json = {
        'id': 'request123',
        'ok': 'approved',
      };

      final approvedRequest = ApprovedRequestRemoteEntity.fromJson(json);

      expect(approvedRequest.id, 'request123');
      expect(approvedRequest.status, 'approved');
    });
  });
}
