import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/update_push_remote_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'pdtpshsttsrs': {'\$t': 'OK'},
  };

  group('UpdatePushRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final entity = UpdatePushRemoteEntity.fromJson(json);

      expect(entity.status, 'OK');
    });
  });

  group('UpdatePushRemoteEntityExtension.toBool', () {
    test('should return true for "OK"', () {
      const entity = UpdatePushRemoteEntity(status: 'OK');
      expect(entity.toBool(), true);
    });

    test('should return false for any other status', () {
      const entity = UpdatePushRemoteEntity(status: 'KO');
      expect(entity.toBool(), false);
    });
  });
}
