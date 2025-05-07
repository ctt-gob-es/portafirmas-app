import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/request_remote_entity.dart';

void main() {
  group('RequestRemoteEntity', () {
    test('should correctly deserialize fromRequestDetail', () {
      final Map<String, dynamic> jsonRequestDetail = {
        'id': '123',
        'priority': 'High',
        'workflow': 'Workflow1',
        'forward': 'Forward1',
        'type': 'Type1',
        'subj': {'__cdata': 'Subject'},
        'snders': {
          'snder': {'__cdata': 'Sender'},
        },
        'ref': {'__cdata': 'Reference'},
        'app': {'__cdata': 'Application'},
        'date': {'\$t': '2024-12-12'},
        'expdate': {'\$t': '2024-12-31'},
        'signlinestype': {'\$t': 'abc'},
        'sgnlines': {
          'sgnline': [
            {
              'rcvr': [
                {'__cdata': 'content1'},
                {'__cdata': 'content2'},
              ],
              'type': 'type1',
            },
          ],
        },
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
        'attachedList': {
          'docid': '1',
          'nm': {'__cdata': '__cdata'},
          'sz': {'\$t': '1024'},
          'mmtp': {'\$t': '1024'},
        },
        'status': 'Approved',
      };

      final requestRemoteEntity =
          RequestRemoteEntity.fromRequestDetail(jsonRequestDetail);

      expect(requestRemoteEntity.id, '123');
      expect(requestRemoteEntity.sender, 'Sender');
      expect(requestRemoteEntity.subject, 'Subject');
      expect(requestRemoteEntity.ref, 'Reference');
      expect(requestRemoteEntity.application, 'Application');
      expect(requestRemoteEntity.date, '2024-12-12');
      expect(requestRemoteEntity.expirationDate, '2024-12-31');
      expect(requestRemoteEntity.listDocs?.length, 1);
      expect(requestRemoteEntity.signLinesType, 'abc');
      expect(requestRemoteEntity.rejectStatus, 'Approved');
    });
  });
}
