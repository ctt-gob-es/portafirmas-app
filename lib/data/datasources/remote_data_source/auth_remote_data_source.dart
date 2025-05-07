
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/auth_api_contract.dart';
import 'package:portafirmas_app/data/models/login_clave_remote_entity.dart';

import 'package:portafirmas_app/data/models/pre_login_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/auth_remote_data_source_contract.dart';

class AuthRemoteDataSource implements AuthRemoteDataSourceContract {
  final AuthApiContract _api;

  AuthRemoteDataSource(this._api);
  @override
  Future<PreLoginRemoteEntity> preLogin() async {
    final response = await _api.preLogin();

    return response;
  }

  @override
  Future<String> loginWithCertificate({
    required String sessionId,
    required String loginTokenSignedBase64,
    required String publicKeyBase64,
  }) {
    return _api.loginWithCertificate(
      sessionId: sessionId,
      loginTokenSignedBase64: loginTokenSignedBase64,
      publicKeyBase64: publicKeyBase64,
    );
  }

  @override
  Future<bool> logOut({
    required String sessionId,
  }) async {
    final response = await _api.logOut(
      sessionId: sessionId,
    );

    return response;
  }

  @override
  Future<LoginClaveRemoteEntity> loginWithClave() async {
    final response = await _api.loginWithClave();

    return response;
  }
}
