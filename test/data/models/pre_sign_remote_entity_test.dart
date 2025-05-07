import 'package:portafirmas_app/data/models/pre_sign_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('PreSignRemoteEntity', () {
    test('fromJson maneja un solo objeto en req', () {
      final Map<String, dynamic> json = {
        'req': {
          'id': '123',
          'status': false,
          'doc': [
            {
              'docid': 'req123',
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
          ],
        },
      };

      final result = PreSignRemoteEntity.fromJson(json);

      expect(result.signRequests.length, 1);
      expect(result.signRequests[0].status, false);
      expect(result.signRequests[0].signDocs, isNotEmpty);
    });

    test('fromJson maneja una lista de objetos en req', () {
      final Map<String, dynamic> json = {
        'req': [
          {'id': '123', 'name': 'Firma1', 'doc': []},
          {'id': '456', 'name': 'Firma2', 'doc': []},
        ],
      };

      final result = PreSignRemoteEntity.fromJson(json);

      expect(result.signRequests.length, 2);
    });
  });
}
