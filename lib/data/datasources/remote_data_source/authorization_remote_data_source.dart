
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
import 'package:portafirmas_app/data/models/add_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/accept_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/authorization_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';

class AuthorizationRemoteDataSource
    implements AuthorizationRemoteDataSourceContract {
  final AuthorizationsApiContract _api;

  AuthorizationRemoteDataSource(this._api);
  @override
  Future<List<AuthDataEntity>> getAuthorizationsList({
    required String sessionId,
  }) async {
    final result = await _api.getAuthorizationsList(
      sessionId: sessionId,
    );

    final List<AuthDataEntity> authorizationList = result.isNotEmpty
        ? result
            .map((authorizationList) => authorizationList.toAuthDataEntity())
            .toList()
        : [];

    return authorizationList;
  }

  @override
  Future<AddAuthorizationRemoteEntity> addAuthorization({
    required String sessionId,
    required NewAuthorizationUserEntity user,
  }) {
    return _api.addAuthorization(
      sessionId: sessionId,
      user: user,
    );
  }

  @override
  Future<RevokeAuthRemoteEntity> revokeAuthorization({
    required String sessionId,
    required String authId,
    required String operation,
  }) {
    return _api.revokeAuthorization(
      sessionId: sessionId,
      authId: authId,
      operation: operation,
    );
  }

  @override
  Future<AcceptAuthRemoteEntity> acceptAuthorization({
    required String sessionId,
    required String authId,
  }) {
    return _api.acceptAuthorization(
      sessionId: sessionId,
      authId: authId,
    );
  }
}
