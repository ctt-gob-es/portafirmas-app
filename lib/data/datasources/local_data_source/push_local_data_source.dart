/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/push_local_data_source_contract.dart';

class PushLocalDatasource implements PushLocalDataSourceContract {
  final FlutterSecureStorage storage;
  static const String _deviceRegisteredKey = 'deviceRegisteredKey';
  static const String _deviceTokenKey = 'deviceTokenKey';
  static const String _mutePreferencesKey = 'mutePreferencesKey';

  const PushLocalDatasource(
    this.storage,
  );

  @override
  Future<bool> getDeviceRegistered() async {
    return (await storage.read(key: _deviceRegisteredKey)) == 'true'
        ? true
        : false;
  }

  @override
  Future<void> saveDeviceRegistered(bool isRegistered) async {
    await storage.write(
      key: _deviceRegisteredKey,
      value: isRegistered.toString(),
    );
  }

  @override
  Future<void> deleteDeviceRegistered() async {
    await storage.delete(key: _deviceRegisteredKey);
  }

  @override
  Future<String?> getDeviceToken() async {
    return await storage.read(key: _deviceTokenKey);
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    await storage.write(key: _deviceTokenKey, value: deviceToken);
  }

  @override
  Future<void> deleteDeviceToken() async {
    await storage.delete(key: _deviceTokenKey);
  }

  @override
  Future<void> saveNotificationsMutePreferences(bool value) async {
    await storage.write(key: _mutePreferencesKey, value: value.toString());
  }

  @override
  Future<void> deleteNotificationsMutePreferences() async {
    await storage.delete(key: _mutePreferencesKey);
  }
}
