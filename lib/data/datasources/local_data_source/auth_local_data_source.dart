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

import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';

class AuthLocalDataSource implements AuthLocalDataSourceContract {
  final FlutterSecureStorage _storage;

  static const _sessionIdKey = 'sessionId';
  static const _publicKeyKey = 'publicKey';
  static const _authMethodKey = 'auth_method';
  static const String _nifKey = 'nifKey';
  static const String _firstTimeKey = 'firstTimeKey';

  AuthLocalDataSource(this._storage);

  @override
  Future<String?> retrieveSessionId() async {
    return await _storage.read(
      key: _sessionIdKey,
    );
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: _sessionIdKey, value: sessionId);
  }

  @override
  Future<String?> retrievePublicKey() async {
    return await _storage.read(
      key: _publicKeyKey,
    );
  }

  @override
  Future<void> savePublicKey(String publicKey) async {
    await _storage.write(key: _publicKeyKey, value: publicKey);
  }

  @override
  Future<void> removeSessionId() async {
    await _storage.write(key: _sessionIdKey, value: null);
  }

  @override
  Future<String?> getLastAuthMethod() {
    return _storage.read(key: _authMethodKey);
  }

  @override
  Future<void> setLastAuthMethod(String authMethod) async {
    await _storage.write(key: _authMethodKey, value: authMethod);
  }

  @override
  Future<String?> getUserNif() async {
    return await _storage.read(key: _nifKey);
  }

  @override
  Future<void> saveUserNif(String nif) async {
    await _storage.write(key: _nifKey, value: nif);
  }

  @override
  Future<void> deleteUserNif() async {
    await _storage.delete(key: _nifKey);
  }

  @override
  Future<void> deleteLastAuthMethod() async {
    await _storage.write(key: _authMethodKey, value: null);
  }

  @override
  Future<bool> isUserFirstTime() async {
    final firstTime = await _storage.read(key: _firstTimeKey);

    return firstTime == null;
  }

  @override
  Future<void> setFirstTime() {
    return _storage.write(key: _firstTimeKey, value: 'false');
  }
}
