import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/pre_sign_req_entity.dart';

void main() {
  group('PreSignReqEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
        'requestId': '123',
        'status': true,
        'signDocs': [
          {
            'id': '123',
            'signOp': 'sign',
            'signFrmt': 'SHA256',
            'signAlgo': 'HMAC',
            'params': 'param1',
            'preSignContent': 'content',
            'preSignEncoding': 'UTF-8',
            'needPre': true,
            'needData': false,
            'signBase': 'base',
            'time': '2024-12-12T10:00:00',
            'pid': 'pid_123',
          },
        ],
      };

      final preSignReqEntity = PreSignReqEntity.fromJson(json);

      expect(preSignReqEntity.requestId, '123');
      expect(preSignReqEntity.status, true);
      expect(preSignReqEntity.signDocs, isNotEmpty);
      expect(preSignReqEntity.signDocs[0].id, '123');
      expect(preSignReqEntity.signDocs[0].signOp, 'sign');
      expect(preSignReqEntity.signDocs[0].signFrmt, 'SHA256');
      expect(preSignReqEntity.signDocs[0].signAlgo, 'HMAC');
      expect(preSignReqEntity.signDocs[0].params, 'param1');
      expect(preSignReqEntity.signDocs[0].preSignContent, 'content');
      expect(preSignReqEntity.signDocs[0].preSignEncoding, 'UTF-8');
      expect(preSignReqEntity.signDocs[0].needPre, true);
      expect(preSignReqEntity.signDocs[0].needData, false);
      expect(preSignReqEntity.signDocs[0].signBase, 'base');
      expect(preSignReqEntity.signDocs[0].time, '2024-12-12T10:00:00');
      expect(preSignReqEntity.signDocs[0].pid, 'pid_123');
    });
  });
}
