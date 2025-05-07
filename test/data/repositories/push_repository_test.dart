import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/push_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/push_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/push_repository.dart';
import 'package:portafirmas_app/domain/repository_contracts/push_repository_contract.dart';
import 'package:push_notifications/main.dart';

import '../instruments/app_version_instruments.dart';
import 'push_repository_test.mocks.dart';

@GenerateMocks([
  PushRemoteDataSourceContract,
  PushLocalDataSourceContract,
  PushNotifications,
  AuthLocalDataSourceContract,
  PushRepository,
  DeviceInfoPlugin,
  AndroidDeviceInfo,
  IosDeviceInfo,
])
void main() {
  late MockPushRemoteDataSourceContract pushRemoteContract;
  late MockPushLocalDataSourceContract pushLocalContract;
  late MockPushNotifications pushNotifications;
  late MockAuthLocalDataSourceContract authLocalContract;
  late PushRepository repository;
  late MockPushRepository mockRepoPush;
  late MockDeviceInfoPlugin deviceInfoPlugin;
  late MockAndroidDeviceInfo androidDeviceInfo;
  late Future<void> initPushNotification =
      pushNotifications.initializePushNotifications(
    domain: 'domain',
    clientId: 'clientId',
    clientSecret: 'clientSecret',
    bearer: 'bearer',
  );

  setUp(() {
    androidDeviceInfo = MockAndroidDeviceInfo();
    deviceInfoPlugin = MockDeviceInfoPlugin();
    mockRepoPush = MockPushRepository();
    pushRemoteContract = MockPushRemoteDataSourceContract();
    pushLocalContract = MockPushLocalDataSourceContract();
    pushNotifications = MockPushNotifications();
    authLocalContract = MockAuthLocalDataSourceContract();
    repository = PushRepository(
      pushRemoteDataSource: pushRemoteContract,
      pushLocalDataSource: pushLocalContract,
      pushNotifications: pushNotifications,
      authLocalDataSource: authLocalContract,
    );
  });

  test(
    'GIVEN a requestPermissionsAndInitialize WHEN device is registered and token matches THEN initializePushListener and return true',
    () async {
      await initPushNotification;

      when(pushLocalContract.getDeviceToken()).thenAnswer((_) async => 'token');
      when(pushLocalContract.getDeviceRegistered())
          .thenAnswer((_) async => true);
      when(pushNotifications.getPushToken()).thenAnswer((_) async => 'token');

      void mockOnReceiveMessage(String? title, String? message) {
        debugPrint('Message received: $title, $message');
      }

      final result = await repository
          .requestPermissionsAndInitialize(mockOnReceiveMessage);

      verify(pushLocalContract.getDeviceToken()).called(1);
      verify(pushLocalContract.getDeviceRegistered()).called(1);
      verify(pushNotifications.getPushToken()).called(1);

      expect(result, isTrue);
    },
  );

  test(
    'GIVEN a unRegisterDevice WHEN call to PushRepository THEN return the correct device',
    () async {
      await initPushNotification;
      when(pushLocalContract.getDeviceToken()).thenAnswer((_) async => 'token');
      when(pushLocalContract.getDeviceRegistered())
          .thenAnswer((_) async => true);
      await repository.unRegisterDevice();

      verify(pushLocalContract.getDeviceToken()).called(1);
      verify(pushLocalContract.getDeviceRegistered()).called(1);
      verify(pushLocalContract.deleteDeviceRegistered()).called(1);
      verify(pushLocalContract.deleteDeviceToken()).called(1);
      verify(authLocalContract.deleteUserNif()).called(1);
      verify(pushLocalContract.deleteNotificationsMutePreferences()).called(1);
    },
  );

  test(
    'GIVEN an updatePush WHEN call to PushRepository THEN return the result',
    () async {
      await initPushNotification;

      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => 'sessionId');
      when(pushLocalContract.saveNotificationsMutePreferences(true))
          .thenAnswer((_) async => true);
      when(pushRemoteContract.updatePush(sessionId: 'sessionId', status: true))
          .thenAnswer((_) async => true);

      final res = await repository.updatePush(status: true);

      verify(authLocalContract.retrieveSessionId()).called(1);
      verify(pushLocalContract.saveNotificationsMutePreferences(false))
          .called(1);
      verify(pushRemoteContract.updatePush(
        sessionId: 'sessionId',
        status: true,
      )).called(1);
      verifyNever(pushNotifications.closeStream()).called(0);

      expect(
        res,
        const Result.success(true),
      );
    },
  );

  test(
    'GIVEN getUserNif WHEN call to PushRepository THEN return the Nif',
    () async {
      when(authLocalContract.getUserNif())
          .thenAnswer((_) => Future(() => 'nif'));

      final result = await repository.getUserNif();
      verify(authLocalContract.getUserNif()).called(1);
      assert(result == 'nif');
    },
  );

  test(
    'GIVEN a saveUserNif WHEN call to PushRepository THEN return the user ',
    () async {
      when(authLocalContract.saveUserNif('nif')).thenAnswer((_) async => true);
      await repository.saveUserNif('nif');

      verify(authLocalContract.saveUserNif('nif')).called(1);
    },
  );
  test(
    'GIVEN a registerDeviceAndListenForPush WHEN call to PushRepository THEN return the register device ',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      String token = LiteralsPushVersion.token;

      when(pushNotifications.getPushToken()).thenAnswer((_) async => token);
      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => LiteralsPushVersion.sessionId);
      when(authLocalContract.getUserNif())
          .thenAnswer((_) async => LiteralsPushVersion.nif);
      when(mockRepoPush.getDeviceUuid())
          .thenAnswer((_) async => LiteralsPushVersion.uuid);
      when(pushNotifications.requestPermissions())
          .thenAnswer((_) async => PermissionStatus.granted);

      await repository.registerDeviceAndListenForPush(
        (title, message) => MessageReceived,
      );

      await pushLocalContract.saveDeviceToken(token);

      await pushLocalContract.saveDeviceRegistered(true);

      final response = await repository.registerDeviceAndListenForPush(
        (title, message) => MessageReceived,
      );

      verify(pushNotifications.getPushToken()).called(2);
      verify(pushLocalContract.saveDeviceToken(token)).called(1);
      verify(pushLocalContract.saveDeviceRegistered(true)).called(1);

      assert(!response);
    },
  );

  test(
    'GIVEN a initializePushListener WHEN call to PushRepository THEN init listener ',
    () {
      when(pushNotifications.startNotificationStream())
          .thenAnswer((_) async => messageStream);

      repository.initializePushListener((title, body) {
        expect(title, 'Test Title');
        expect(body, 'Test Body');
      });
    },
  );
  test(
    'GIVEN platform is Android WHEN getDeviceUuid is called THEN return androidId',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      when(deviceInfoPlugin.androidInfo)
          .thenAnswer((_) async => androidDeviceInfo);
      when(androidDeviceInfo.androidId).thenAnswer((_) => 'androidId');

      await repository.getDeviceUuid();

      assert(androidDeviceInfo.androidId == 'androidId');

      debugDefaultTargetPlatformOverride = null;
    },
  );
}
