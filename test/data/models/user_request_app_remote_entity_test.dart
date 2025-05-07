import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/user_request_app_remote_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'ppId': {'\$t': '123'},
    'ppName': {'\$t': 'MyApp'},
  };

  group('UserRequestAppRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final entity = UserRequestAppRemoteEntity.fromJson(json);

      expect(entity.id, '123');
      expect(entity.appName, 'MyApp');
    });
  });
}
