/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/models/push_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/push_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/push_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/push_repository_contract.dart';
import 'package:push_notifications/main.dart';

class PushRepository implements PushRepositoryContract {
  final PushRemoteDataSourceContract pushRemoteDataSource;
  final PushLocalDataSourceContract pushLocalDataSource;
  final PushNotifications pushNotifications;
  final AuthLocalDataSourceContract authLocalDataSource;

  PushRepository({
    required this.pushRemoteDataSource,
    required this.pushLocalDataSource,
    required this.pushNotifications,
    required this.authLocalDataSource,
  });

  @override
  Future<bool> requestPermissionsAndInitialize(
    MessageReceived onReceiveMessage,
  ) async {
    await initializePushNotifications();

    String? pushTkn = await pushNotifications.getPushToken();

    final deviceIsRegistered = await pushLocalDataSource.getDeviceRegistered();
    final actualPushToken = await pushLocalDataSource.getDeviceToken();
    debugPrint('pushToken: $pushTkn');
    if (actualPushToken != null && deviceIsRegistered) {
      if (pushTkn != actualPushToken) {
        return await registerDeviceAndListenForPush(onReceiveMessage);
      }

      initializePushListener(onReceiveMessage);
      saveNotificationsMutePreferences(false);

      return true;
    } else {
      return await registerDeviceAndListenForPush(onReceiveMessage);
    }
  }

  @override
  Future<void> unRegisterDevice() async {
    await initializePushNotifications();
    final pushToken = await pushLocalDataSource.getDeviceToken();
    final deviceRegistered = await pushLocalDataSource.getDeviceRegistered();
    if (pushToken == null || !deviceRegistered) {
      return;
    }
    await pushLocalDataSource.deleteDeviceRegistered();
    await pushLocalDataSource.deleteDeviceToken();
    await authLocalDataSource.deleteUserNif();
    await pushLocalDataSource.deleteNotificationsMutePreferences();
  }

  @override
  Future<Result<bool>> updatePush({required bool status}) async {
    final sessionId = await authLocalDataSource.retrieveSessionId();
    await initializePushNotifications();
    await pushLocalDataSource.saveNotificationsMutePreferences(!status);
    try {
      final res = await pushRemoteDataSource.updatePush(
        sessionId: sessionId ?? '',
        status: status,
      );

      if (res && !status) {
        pushNotifications.closeStream();
      }

      return const Result.success(true);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<String?> getUserNif() {
    return authLocalDataSource.getUserNif();
  }

  @override
  Future<void> saveNotificationsMutePreferences(bool value) {
    return pushLocalDataSource.saveNotificationsMutePreferences(value);
  }

  @override
  Future<void> saveUserNif(String nif) {
    return authLocalDataSource.saveUserNif(nif);
  }

  Future<bool> registerDeviceAndListenForPush(
    MessageReceived onReceiveMessage,
  ) async {
    String? pushTkn = await pushNotifications.getPushToken();
    final sessionId = await authLocalDataSource.retrieveSessionId();
    final nif = await authLocalDataSource.getUserNif();
    String? uuid = await getDeviceUuid();

    if (pushTkn != null && uuid != null && nif != null) {
      await pushLocalDataSource.saveDeviceToken(pushTkn);

      final res = await pushRemoteDataSource.registerPush(
        sessionId: sessionId ?? '',
        petition: PushPetitionRemoteEntity(
          platform: Platform.isAndroid ? 1 : 2,
          pushToken: pushTkn,
          uuid: uuid,
          nif: nif,
        ),
      );

      if (res) {
        await pushLocalDataSource.saveDeviceRegistered(res);
        PermissionStatus permissionStatus =
            await pushNotifications.requestPermissions();
        switch (permissionStatus) {
          case PermissionStatus.granted:
          case PermissionStatus.provisional:
            initializePushListener(onReceiveMessage);
            saveNotificationsMutePreferences(false);
            return true;
          case PermissionStatus.unknown:
          case PermissionStatus.denied:
            saveNotificationsMutePreferences(true);
            return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> initializePushNotifications() {
    return pushNotifications.initializePushNotifications(
      domain: '',
      clientId: '',
      clientSecret: '',
      bearer: '',
    );
  }

  void initializePushListener(
    Function(String? title, String? body) onNotificationReceive,
  ) async {
    await initializePushNotifications();
    pushNotifications.startNotificationStream();
    messageStream.listen(
      (msg) {
        onNotificationReceive(msg.title, msg.body);
      },
    );
  }

  Future<String?> getDeviceUuid() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.identifierForVendor;
    } else {
      return null;
    }
  }

  @override
  Future<String?> checkNotificationPermStatus() async {
    return await pushNotifications.checkNotificationPermStatus();
  }

  @override
  Future<PermissionStatus> requestPermissions() async {
    return await pushNotifications.requestPermissions();
  }
}
