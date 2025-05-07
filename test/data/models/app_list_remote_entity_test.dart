import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/app_list_remote_entity.dart';

void main() {
  group('AppListRemoteEntity', () {
    test('fromJson should return a valid AppListRemoteEntity instance', () {
      final json = {
        'app': [
          {
            'id': '1',
            '__cdata': 'App 1',
          },
          {
            'id': '2',
            '__cdata': 'App 2',
          },
        ],
      };

      final result = AppListRemoteEntity.fromJson(json);

      expect(result, isA<AppListRemoteEntity>());
      expect(result.appList.length, 2);
      expect(result.appList[0].id, '1');
      expect(result.appList[0].appName, 'App 1');
      expect(result.appList[1].id, '2');
      expect(result.appList[1].appName, 'App 2');
    });
  });
}
