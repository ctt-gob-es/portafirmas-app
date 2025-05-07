import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/sign_line_remote_entity.dart';

void main() {
  group('SignLineRemoteEntity', () {
    test('should parse JSON with a list of rcvr correctly', () {
      final Map<String, dynamic> json = {
        'rcvr': [
          {'__cdata': 'content1'},
          {'__cdata': 'content2'},
        ],
        'type': 'type1',
      };

      final entity = SignLineRemoteEntity.fromJson(json);

      expect(entity.signName.length, 2);
      expect(entity.signName[0].signContent, 'content1');
      expect(entity.signName[1].signContent, 'content2');
      expect(entity.type, 'type1');
    });

    test('should handle missing or null type correctly', () {
      final Map<String, dynamic> json = {
        'rcvr': [
          {'__cdata': 'content1'},
          {'__cdata': 'content2'},
        ],
      };

      final entity = SignLineRemoteEntity.fromJson(json);

      expect(entity.type, null);
    });
  });
}
