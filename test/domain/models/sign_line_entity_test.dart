import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/sign_line_content_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_line_remote_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'signName': [
      {'signContent': 'Content 1'},
      {'signContent': 'Content 2'},
    ],
    'type': 'exampleType',
  };
  group('SignLineEntityExtension', () {
    test('should parse JSON correctly', () {
      final signLineEntity = SignLineEntity.fromJson(json);

      expect(signLineEntity.signName.length, 2);
      expect(signLineEntity.signName[0].signContent, 'Content 1');
      expect(signLineEntity.signName[1].signContent, 'Content 2');
      expect(signLineEntity.type, 'exampleType');
    });
    test('should convert SignLineRemoteEntity to SignLineEntity', () {
      const signLineRemoteEntity = SignLineRemoteEntity(
        signName: [
          SignLineContentRemoteEntity(signContent: 'Content 1'),
          SignLineContentRemoteEntity(signContent: 'Content 2'),
        ],
        type: 'exampleType',
      );

      final signLineEntity = signLineRemoteEntity.toSignLineEntity();

      expect(signLineEntity.signName.length, 2);
      expect(signLineEntity.signName[0].signContent, 'Content 1');
      expect(signLineEntity.signName[1].signContent, 'Content 2');
      expect(signLineEntity.type, 'exampleType');
    });
  });
}
