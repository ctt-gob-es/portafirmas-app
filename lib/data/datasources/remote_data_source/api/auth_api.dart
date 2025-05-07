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

class AuthApi extends AuthApiContract {
  AuthApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<PreLoginRemoteEntity> preLogin() async {
    final response = await get(
      operation: 10,
      xmlData: '<lgnrq />',
    );

    Map<String, dynamic> result = response.data;

    return PreLoginRemoteEntity.fromJsonWithCookie(
      result['lgnrq'],
      response.headers,
    );
  }

  @override
  Future<String> loginWithCertificate({
    required String sessionId,
    required String loginTokenSignedBase64,
    required String publicKeyBase64,
  }) async {
    final String xml =
        '<rqtvl><cert>$publicKeyBase64</cert><pkcs1>$loginTokenSignedBase64</pkcs1></rqtvl>';
    final response = await post(
      operation: 11,
      xmlData: xml,
      sessionCookie: sessionId,
    );
    Map<String, dynamic> result = response.data;

    if (result['vllgnrq']?['ok'] == 'true') {
      return result['vllgnrq']?['dni'];
    } else {
      final data = result['vllgnrq']?['ec'] ?? result['vllgnrq']?['er'];
      throw Exception(data);
    }
  }

  @override
  Future<bool> logOut({
    required String sessionId,
  }) async {
    final response = await post(
      operation: 12,
      xmlData: '<lgorq/>',
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (result.containsKey('lgorq')) {
      return true;
    } else {
      throw (Exception('Error in authentication'));
    }
  }

  @override
  Future<LoginClaveRemoteEntity> loginWithClave() async {
    const String xml = '<lgnrq />';
    final response = await get(
      operation: 14,
      xmlData: xml,
    );
    Map<String, dynamic>? result = response.data;
    if (result != null && result.containsKey('lgnrq')) {
      return LoginClaveRemoteEntity.fromJsonWithCookie(
        result['lgnrq']['url'],
        response.headers,
      );
    } else {
      throw Exception(response.data ?? 'error');
    }
  }
}
