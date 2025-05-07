import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/pre_sign_doc_remote_entity.dart';

void main() {
  group('PreSignDocRemoteEntity', () {
    test('should parse from JSON correctly', () {
      final jsonData = {
        'docid': '123',
        'cop': 'sign',
        'sigfrmt': 'format1',
        'mdalgo': 'algo1',
        'params': {'__cdata': 'params'},
        'result': {
          'p': [
            {'n': 'PRE', '\$t': 'content1'},
            {'n': 'NEED_PRE', '\$t': 'true'},
            {'n': 'ENCODING', '\$t': 'utf-8'},
            {'n': 'TIME', '\$t': '2024-12-12'},
            {'n': 'NEED_DATA', '\$t': false},
            {'n': 'PID', '\$t': '122'},
            {'n': 'BASE', '\$t': 'baseValue'},
          ],
        },
      };

      final preSignDocRemoteEntity = PreSignDocRemoteEntity.fromJson(jsonData);

      expect(preSignDocRemoteEntity.id, '123');
      expect(preSignDocRemoteEntity.signOp, 'sign');
      expect(preSignDocRemoteEntity.signFrmt, 'format1');
      expect(preSignDocRemoteEntity.signAlgo, 'algo1');
      expect(preSignDocRemoteEntity.params, 'params');
      expect(preSignDocRemoteEntity.preSignContent, 'content1');
      expect(preSignDocRemoteEntity.preSignEncoding, 'utf-8');
      expect(preSignDocRemoteEntity.needPre, true);
      expect(preSignDocRemoteEntity.time, '2024-12-12');
      expect(preSignDocRemoteEntity.signBase, 'baseValue');
    });

    test('should handle missing or null values gracefully', () {
      final jsonData = {
        'docid': '123',
        'cop': 'sign',
        'sigfrmt': 'format1',
        'mdalgo': 'algo1',
        'params': {'__cdata': 'params'},
        'result': {
          'p': [
            {'n': 'PRE', '\$t': 'content1'},
            {'n': 'NEED_PRE', '\$t': 'true'},
          ],
        },
      };

      final preSignDocRemoteEntity = PreSignDocRemoteEntity.fromJson(jsonData);

      expect(preSignDocRemoteEntity.preSignEncoding, isNull);
      expect(preSignDocRemoteEntity.time, isNull);
    });

    test(
      'should convert PreSignDocRemoteEntity to PreSignDocEntity correctly',
      () {
        const remoteEntity = PreSignDocRemoteEntity(
          id: '123',
          signOp: 'sign',
          signFrmt: 'format1',
          signAlgo: 'algo1',
          params: 'params',
          preSignContent: 'content1',
          preSignEncoding: 'utf-8',
          needPre: true,
          needData: false,
          signBase: 'baseValue',
          time: '2024-12-12',
          pid: '122',
        );

        final entity = remoteEntity.toPreSignDocEntity();

        expect(entity.id, '123');
        expect(entity.signOp, 'sign');
        expect(entity.signFrmt, 'format1');
        expect(entity.signAlgo, 'algo1');
        expect(entity.params, 'params');
        expect(entity.preSignContent, 'content1');
        expect(entity.preSignEncoding, 'utf-8');
        expect(entity.needPre, true);
        expect(entity.needData, false);
        expect(entity.signBase, 'baseValue');
        expect(entity.time, '2024-12-12');
        expect(entity.pid, '122');
      },
    );
  });
}
