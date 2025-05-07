import 'package:portafirmas_app/data/models/annexes_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnnexesRemoteEntity', () {
    test('should convert from JSON correctly', () {
      final Map<String, dynamic> json = {
        'docid': '12345',
        'nm': {'__cdata': 'Annex A'},
        'sz': {'\$t': '100KB'},
        'mmtp': {'\$t': 'application/pdf'},
      };

      final entity = AnnexesRemoteEntity.fromJson(json);

      expect(entity.annexeId, '12345');
      expect(entity.annexeName, 'Annex A');
      expect(entity.annexeSize, '100KB');
      expect(entity.mediaType, 'application/pdf');
    });

    test('should convert to AnnexesEntity correctly', () {
      const entity = AnnexesRemoteEntity(
        annexeId: '12345',
        annexeName: 'Annex A',
        annexeSize: '100KB',
        mediaType: 'application/pdf',
      );

      final annexEntity = entity.toAnnexesEntity();

      expect(annexEntity.annexeId, '12345');
      expect(annexEntity.annexeName, 'Annex A');
      expect(annexEntity.annexeSize, '100KB');
      expect(annexEntity.mediaType, 'application/pdf');
    });
  });
}
