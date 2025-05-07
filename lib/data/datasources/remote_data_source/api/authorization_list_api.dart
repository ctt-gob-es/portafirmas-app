/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/authorization_list_api_contract.dart';
import 'package:portafirmas_app/data/models/accept_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/add_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/auth_data_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_remote_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';

class AuthorizationsApi extends AuthorizationsApiContract {
  AuthorizationsApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<List<AuthDataRemoteEntity>> getAuthorizationsList({
    required String sessionId,
  }) async {
    String xml = '<rqt/>';

    final response = await post(
      operation: 24,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (isProxyVersionUnder25(result)) {
      //Proxy version is < 25 so there is no user roles, validators and authorizations
      return [];
    }

    if (!result.containsKey('rsauthlist')) {
      throw Exception('Error obtaining atuhorizations');
    }

    dynamic auth = result['rsauthlist']['authlist']['auth'];

    List<dynamic> authlist = auth == null
        ? []
        : auth is List
            ? auth
            : [auth];

    List<AuthDataRemoteEntity> authorizations = authlist.isNotEmpty
        ? authlist
            .map(
              (authorization) => AuthDataRemoteEntity.fromJson(authorization),
            )
            .toList()
        : [];

    return authorizations;
  }

  @override
  Future<RevokeAuthRemoteEntity> revokeAuthorization({
    required String sessionId,
    required String authId,
    required String operation,
  }) async {
    String xml = "<rquserauth id='$authId' op='$operation'/>";

    final response = await post(
      operation: 26,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['rs'];

    if (result.containsKey('result') && !result.containsKey('errorMsg')) {
      return RevokeAuthRemoteEntity.fromJson(result);
    } else {
      throw Exception(result['errorMsg']['\$t']);
    }
  }

  @override
  Future<AddAuthorizationRemoteEntity> addAuthorization({
    required String sessionId,
    required NewAuthorizationUserEntity user,
  }) async {
    String xml =
        "<rqsaveauth type='${user.type.toUpperCase()}'><authuser dni='${user.nif}' id='${user.id}'></authuser><startdate></startdate>${user.startDate}<expdate>${user.expDate}</expdate><observations>${user.observations}</observations></rqsaveauth>";

    final response = await post(
      operation: 25,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['rs'];

    if (result.containsKey('result') && !result.containsKey('errorMsg')) {
      return AddAuthorizationRemoteEntity.fromJson(result);
    } else {
      throw (Exception('Error trying to add authorization'));
    }
  }

  @override
  Future<AcceptAuthRemoteEntity> acceptAuthorization({
    required String sessionId,
    required String authId,
  }) async {
    String xml = "<rquserauth id='$authId'/>";

    final response = await post(
      operation: 27,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['rs'];

    if (result.containsKey('result')) {
      return AcceptAuthRemoteEntity.fromJson(result);
    } else {
      throw (Exception('Error trying to accept authorization'));
    }
  }
}
