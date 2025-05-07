import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/app_version_remote_entity.dart';
import 'package:portafirmas_app/domain/models/app_version_entity.dart';

void main() {
  group('AppVersionRemoteEntity', () {
    test('should parse fromJson correctly', () {
      final json = {
        'minAppVersion': '1.0.0',
        'warningAppVersion': '1.2.0',
      };

      final result = AppVersionRemoteEntity.fromJson(json);

      expect(result.minAppVersion, '1.0.0');
      expect(result.warningAppVersion, '1.2.0');
    });

    test('should convert to AppVersionEntity correctly using extension', () {
      const appVersionRemoteEntity = AppVersionRemoteEntity(
        minAppVersion: '1.0.0',
        warningAppVersion: '1.2.0',
      );

      final result = appVersionRemoteEntity.toAppVersionEntity();

      expect(result, isA<AppVersionEntity>());
      expect(result.minAppVersion, '1.0.0');
      expect(result.warningAppVersion, '1.2.0');
    });
  });
}
