import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/request_app_remote_entity.dart';

void main() {
  group('RequestAppRemoteEntity', () {
    test('fromJson should return a valid instance from JSON', () {
      final json = {
        'id': '123',
        '__cdata': 'AppNameExample',
      };

      final requestAppRemoteEntity = RequestAppRemoteEntity.fromJson(json);

      expect(requestAppRemoteEntity, isA<RequestAppRemoteEntity>());
      expect(requestAppRemoteEntity.id, '123');
      expect(requestAppRemoteEntity.appName, 'AppNameExample');
    });

    test('toJson should return a valid JSON representation', () {
      const requestAppRemoteEntity = RequestAppRemoteEntity(
        id: '123',
        appName: 'AppNameExample',
      );

      final json = requestAppRemoteEntity.toJson();

      expect(json['id'], '123');
      expect(json['__cdata'], 'AppNameExample');
    });

    test('should create a valid RequestAppRemoteEntity instance', () {
      const requestAppRemoteEntity = RequestAppRemoteEntity(
        id: '123',
        appName: 'AppNameExample',
      );

      expect(requestAppRemoteEntity.id, '123');
      expect(requestAppRemoteEntity.appName, 'AppNameExample');
    });
  });
}
