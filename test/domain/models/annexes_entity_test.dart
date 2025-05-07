import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/annexes_entity.dart';

void main() {
  final json = {
    'annexeId': '12345',
    'annexeName': 'Annex 1',
    'annexeSize': '1024',
    'mediaType': 'application/pdf',
  };

  group('AnnexesEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final annexesEntity = AnnexesEntity.fromJson(json);

      expect(annexesEntity.annexeId, '12345');
      expect(annexesEntity.annexeName, 'Annex 1');
      expect(annexesEntity.annexeSize, '1024');
      expect(annexesEntity.mediaType, 'application/pdf');
    });
  });
}
