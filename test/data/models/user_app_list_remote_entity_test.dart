import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/user_app_list_remote_entity.dart';

void main() {
  final Map<String, dynamic> json = {
    'pp': [
      {
        'ppId': {'\$t': '123'},
        'ppName': {'\$t': 'App1'},
      },
      {
        'ppId': {'\$t': '456'},
        'ppName': {'\$t': 'App2'},
      },
    ],
  };

  group('UserAppListRemoteEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final entity = UserAppListRemoteEntity.fromJson(json);

      expect(entity.userAppList.length, 2);
      expect(entity.userAppList[0].id, '123');
      expect(entity.userAppList[0].appName, 'App1');
      expect(entity.userAppList[1].id, '456');
      expect(entity.userAppList[1].appName, 'App2');
    });
  });
}
