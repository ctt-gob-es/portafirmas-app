import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/pre_sign_req_remote_entity.dart';

void main() {
  group('PreSignReqRemoteEntity', () {
    test('should parse from JSON correctly with multiple documents', () {
      final jsonData = {
        'id': 'req123',
        'status': 'OK',
        'doc': [
          {
            'docid': 'doc1',
            'cop': 'sign',
            'sigfrmt': 'format1',
            'mdalgo': 'algo1',
            'params': {'__cdata': 'params1'},
            'result': {
              'p': [
                {'n': 'PRE', '\$t': 'content1'},
                {'n': 'ENCODING', '\$t': 'utf-8'},
                {'n': 'NEED_PRE', '\$t': 'true'},
                {'n': 'TIME', '\$t': '2024-12-12'},
                {'n': 'NEED_DATA', '\$t': false},
                {'n': 'PID', '\$t': '123'},
              ],
            },
          },
          {
            'docid': 'doc2',
            'cop': 'sign',
            'sigfrmt': 'format2',
            'mdalgo': 'algo2',
            'params': {'__cdata': 'params2'},
            'result': {
              'p': [
                {'n': 'PRE', '\$t': 'content2'},
                {'n': 'ENCODING', '\$t': 'utf-16'},
                {'n': 'NEED_PRE', '\$t': 'false'},
                {'n': 'TIME', '\$t': '2024-12-13'},
                {'n': 'NEED_DATA', '\$t': true},
                {'n': 'PID', '\$t': '124'},
              ],
            },
          },
        ],
      };

      final entity = PreSignReqRemoteEntity.fromJson(jsonData);

      expect(entity.requestId, 'req123');
      expect(entity.status, true);
      expect(entity.signDocs.length, 2);

      final doc1 = entity.signDocs[0];
      expect(doc1.id, 'doc1');
      expect(doc1.signOp, 'sign');
      expect(doc1.signFrmt, 'format1');
      expect(doc1.signAlgo, 'algo1');
      expect(doc1.params, 'params1');
      expect(doc1.preSignContent, 'content1');
      expect(doc1.preSignEncoding, 'utf-8');
      expect(doc1.needPre, true);
      expect(doc1.time, '2024-12-12');
      expect(doc1.pid, '123');

      final doc2 = entity.signDocs[1];
      expect(doc2.id, 'doc2');
      expect(doc2.signOp, 'sign');
      expect(doc2.signFrmt, 'format2');
      expect(doc2.signAlgo, 'algo2');
      expect(doc2.params, 'params2');
      expect(doc2.preSignContent, 'content2');
      expect(doc2.preSignEncoding, 'utf-16');
      expect(doc2.needPre, false);
      expect(doc2.time, '2024-12-13');
      expect(doc2.pid, '124');
    });

    test('should parse from JSON correctly with a single document', () {
      final jsonData = {
        'id': 'req124',
        'status': 'KO',
        'doc': {
          'docid': 'doc3',
          'cop': 'sign',
          'sigfrmt': 'format3',
          'mdalgo': 'algo3',
          'params': {'__cdata': 'params3'},
          'result': {
            'p': [
              {'n': 'PRE', '\$t': 'content3'},
              {'n': 'ENCODING', '\$t': 'utf-32'},
              {'n': 'NEED_PRE', '\$t': 'true'},
              {'n': 'TIME', '\$t': '2024-12-14'},
              {'n': 'NEED_DATA', '\$t': false},
              {'n': 'PID', '\$t': '125'},
            ],
          },
        },
      };

      final entity = PreSignReqRemoteEntity.fromJson(jsonData);

      expect(entity.requestId, 'req124');
      expect(entity.status, false);
      expect(entity.signDocs.length, 1);

      final doc = entity.signDocs[0];
      expect(doc.id, 'doc3');
      expect(doc.signOp, 'sign');
      expect(doc.signFrmt, 'format3');
      expect(doc.signAlgo, 'algo3');
      expect(doc.params, 'params3');
      expect(doc.preSignContent, 'content3');
      expect(doc.preSignEncoding, 'utf-32');
      expect(doc.needPre, true);
      expect(doc.time, '2024-12-14');
      expect(doc.pid, '125');
    });
  });
}
