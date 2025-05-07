import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/user_role_remote_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'id': {'\$t': '123'},
    'roleName': {'\$t': 'admin'},
    'userName': {'\$t': 'johndoe'},
    'dni': {'\$t': '987654321'},
  };

  group('UserRoleRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final entity = UserRoleRemoteEntity.fromJson(json);

      expect(entity.id, '123');
      expect(entity.roleName, 'admin');
      expect(entity.userName, 'johndoe');
      expect(entity.dni, '987654321');
    });
  });
}
