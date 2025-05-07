
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';
import 'package:portafirmas_app/data/models/accept_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/auth_data_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/add_authorization_remote_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';

abstract class AuthorizationsApiContract extends PortafirmaApiBase {
  AuthorizationsApiContract({
    required super.dio,
    required super.serverLocalDataSource,
  });
  Future<List<AuthDataRemoteEntity>> getAuthorizationsList({
    required String sessionId,
  });

  Future<AddAuthorizationRemoteEntity> addAuthorization({
    required String sessionId,
    required NewAuthorizationUserEntity user,
  });

  Future<RevokeAuthRemoteEntity> revokeAuthorization({
    required String sessionId,
    required String authId,
    required String operation,
  });
  Future<AcceptAuthRemoteEntity> acceptAuthorization({
    required String sessionId,
    required String authId,
  });
}
