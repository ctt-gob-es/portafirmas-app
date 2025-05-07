import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/document_remote_entity.dart';

void main() {
  final json = {
    'docid': '12345',
    'nm': {'__cdata': 'Document Name'},
    'sz': {'\$t': '1024'},
    'sigfrmt': {'\$t': 'SHA256'},
    'mdalgo': {'__cdata': 'HMAC'},
    'params': 'param1',
  };

  group('DocumentRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final document = DocumentRemoteEntity.fromJson(json);

      expect(document.docId, '12345');
      expect(document.docName, 'Document Name');
      expect(document.docSize, '1024');
      expect(document.signFrmt, 'SHA256');
      expect(document.signAlgo, 'HMAC');
      expect(document.params, 'param1');
    });
  });
}
