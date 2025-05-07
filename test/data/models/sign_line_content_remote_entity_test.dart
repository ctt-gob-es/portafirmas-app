import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/sign_line_content_remote_entity.dart';

void main() {
  group('SignLineContentRemoteEntity', () {
    test('fromJson should return a valid instance from JSON', () {
      final json = {
        '__cdata': 'This is some sign content',
      };

      final signLineContent = SignLineContentRemoteEntity.fromJson(json);

      expect(signLineContent, isA<SignLineContentRemoteEntity>());
      expect(signLineContent.signContent, 'This is some sign content');
    });

    test('should create a valid SignLineContentRemoteEntity instance', () {
      const signLineContent =
          SignLineContentRemoteEntity(signContent: 'This is some sign content');

      expect(signLineContent.signContent, 'This is some sign content');
    });
  });
}
