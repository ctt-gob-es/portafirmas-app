import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/sign_line_content_remote_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_content_entity.dart';

void main() {
  group('SignLineContentEntity', () {
    test('should correctly parse JSON into SignLineContentEntity', () {
      final json = {
        'signContent': 'Sample Sign Content',
      };

      final entity = SignLineContentEntity.fromJson(json);

      expect(entity.signContent, 'Sample Sign Content');
    });

    test(
      'should convert SignLineContentRemoteEntity to SignLineContentEntity',
      () {
        const signLineContentRemoteEntity = SignLineContentRemoteEntity(
          signContent: 'Sample Sign Content',
        );

        final signLineContentEntity =
            signLineContentRemoteEntity.toSignLineContentEntity();

        expect(signLineContentEntity.signContent, 'Sample Sign Content');
      },
    );
  });
}
