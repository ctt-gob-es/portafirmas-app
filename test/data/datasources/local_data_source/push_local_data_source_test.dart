import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/push_local_data_source.dart';

import 'push_local_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late PushLocalDatasource pushLocalDatasource;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    pushLocalDatasource = PushLocalDatasource(mockStorage);
  });

  group('PushLocalDatasource', () {
    test('should retrieve device registered status', () async {
      when(mockStorage.read(key: 'deviceRegisteredKey'))
          .thenAnswer((_) async => 'true');
      final isRegistered = await pushLocalDatasource.getDeviceRegistered();
      expect(isRegistered, true);
      verify(mockStorage.read(key: 'deviceRegisteredKey')).called(1);
    });

    test('should save device registered status', () async {
      await pushLocalDatasource.saveDeviceRegistered(true);
      verify(mockStorage.write(key: 'deviceRegisteredKey', value: 'true'))
          .called(1);
    });

    test('should delete device registered status', () async {
      await pushLocalDatasource.deleteDeviceRegistered();
      verify(mockStorage.delete(key: 'deviceRegisteredKey')).called(1);
    });

    test('should retrieve device token', () async {
      when(mockStorage.read(key: 'deviceTokenKey'))
          .thenAnswer((_) async => 'test-device-token');
      final token = await pushLocalDatasource.getDeviceToken();
      expect(token, 'test-device-token');
      verify(mockStorage.read(key: 'deviceTokenKey')).called(1);
    });

    test('should save device token', () async {
      const token = 'test-device-token';
      await pushLocalDatasource.saveDeviceToken(token);
      verify(mockStorage.write(key: 'deviceTokenKey', value: token)).called(1);
    });

    test('should delete device token', () async {
      await pushLocalDatasource.deleteDeviceToken();
      verify(mockStorage.delete(key: 'deviceTokenKey')).called(1);
    });

    test('should save mute notifications preferences', () async {
      await pushLocalDatasource.saveNotificationsMutePreferences(true);
      verify(mockStorage.write(key: 'mutePreferencesKey', value: 'true'))
          .called(1);
    });

    test('should delete mute notifications preferences', () async {
      await pushLocalDatasource.deleteNotificationsMutePreferences();
      verify(mockStorage.delete(key: 'mutePreferencesKey')).called(1);
    });
  });
}
