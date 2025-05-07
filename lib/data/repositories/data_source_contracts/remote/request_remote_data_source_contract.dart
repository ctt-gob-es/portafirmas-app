
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/request_app_entity.dart';

import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/user_role_entity.dart';
import 'package:portafirmas_app/domain/models/users_search_entity.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';

abstract class RequestRemoteDataSourceContract {
  Future<RequestListRemoteEntity> getRequests({
    required String sessionId,
    required RequestPetitionRemoteEntity petition,
  });

  Future<List<RequestAppEntity>> getUserRequestApps({
    required String sessionId,
  });

  Future<List<RequestAppEntity>> getAllRequestApps({
    required String sessionId,
    required String publicKeyBase64,
  });

  Future<RequestEntity> detailRequest({
    required String sessionId,
    required String requestId,
  });
  Future<List<UserRoleEntity>> getUserRoles({
    required String sessionId,
  });
  Future<List<UsersSearchEntity>> getUsersBySearch({
    required String sessionId,
    required String name,
    required String mode,
  });

  Future<String> downloadDocument({
    required String sessionId,
    required String documentId,
    required String documentName,
    required int operation,
  });

  Future<List<RevokedRequestEntity>> revokeRequests({
    required String sessionId,
    required String reason,
    required List<String> requestIds,
  });
  Future<List<ApprovedRequestEntity>> approveRequests({
    required String sessionId,
    required List<String> requestIds,
  });

  Future<List<ValidatePetitionEntity>> validatePetitions({
    required String sessionId,
    required List<String> petitionId,
  });
}
