import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/pre_sign_doc_entity.dart';

void main() {
  group('PreSignDocEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
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
      };

      final preSignDocEntity = PreSignDocEntity.fromJson(json);

      expect(preSignDocEntity.id, '123');
      expect(preSignDocEntity.signOp, 'sign');
      expect(preSignDocEntity.signFrmt, 'SHA256');
      expect(preSignDocEntity.signAlgo, 'HMAC');
      expect(preSignDocEntity.params, 'param1');
      expect(preSignDocEntity.preSignContent, 'content');
      expect(preSignDocEntity.preSignEncoding, 'UTF-8');
      expect(preSignDocEntity.needPre, true);
      expect(preSignDocEntity.needData, false);
      expect(preSignDocEntity.signBase, 'base');
      expect(preSignDocEntity.time, '2024-12-12T10:00:00');
      expect(preSignDocEntity.pid, 'pid_123');
    });
  });
}
