import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';

void main() {
  group('RequestListRemoteEntity', () {
    test('should correctly deserialize fromJson with list of requests', () {
      final Map<String, dynamic> jsonRequestList = {
        'list': {
          'n': '2',
          'rqt': [
            {
              'id': '123',
              'priority': 'High',
              'workflow': 'Workflow1',
              'forward': 'Forward1',
              'type': 'Type1',
              'subj': {'__cdata': 'Subject'},
              'snder': {'__cdata': 'Sender'},
              'view': {'\$t': 't'},
              'date': {'\$t': '2024-12-12'},
              'expdate': {'\$t': '2024-12-31'},
              'docs': {
                'doc': [
                  {
                    'docid': '12345',
                    'nm': {'__cdata': 'Document Name'},
                    'sz': {'\$t': '1024'},
                    'sigfrmt': {'\$t': 'SHA256'},
                    'mdalgo': {'__cdata': 'HMAC'},
                    'params': 'param1',
                  },
                ],
              },
              'status': 'Approved',
            },
          ],
        },
      };

      final requestListRemoteEntity =
          RequestListRemoteEntity.fromJson(jsonRequestList);

      expect(requestListRemoteEntity.count, '2');
      expect(requestListRemoteEntity.requestList.length, 1);
      final firstRequest = requestListRemoteEntity.requestList[0];
      expect(firstRequest.id, '123');
      expect(firstRequest.priority, 'High');
      expect(firstRequest.subject, 'Subject');
      expect(firstRequest.sender, 'Sender');
    });

    test(
      'should correctly deserialize fromJson when n is 0 and empty request list',
      () {
        final Map<String, dynamic> jsonEmptyRequestList = {
          'list': {'n': '0', 'rqt': []},
        };

        final requestListRemoteEntity =
            RequestListRemoteEntity.fromJson(jsonEmptyRequestList);

        expect(requestListRemoteEntity.count, '0');

        expect(requestListRemoteEntity.requestList.isEmpty, true);
      },
    );
  });
}
