import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/users_search_remote_entity.dart';

void main() {
  group('UsersSearchRemoteEntity', () {
    test('should correctly serialize to JSON', () {
      const entity = UsersSearchRemoteEntity(
        id: '123',
        dni: '456789',
        name: 'John Doe',
      );

      final expectedJson = {
        'id': '123',
        'dni': '456789',
        '__cdata': 'John Doe',
      };

      final json = entity.toJson();

      expect(json, expectedJson);
    });

    test('should correctly deserialize from JSON', () {
      final json = {
        'id': '123',
        'dni': '456789',
        '__cdata': 'John Doe',
      };

      final entity = UsersSearchRemoteEntity.fromJson(json);

      expect(entity.id, '123');
      expect(entity.dni, '456789');
      expect(entity.name, 'John Doe');
    });
  });
}
