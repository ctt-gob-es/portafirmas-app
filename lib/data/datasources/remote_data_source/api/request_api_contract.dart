
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

import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';
import 'package:portafirmas_app/data/models/app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/approved_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_role_remote_entity.dart';
import 'package:portafirmas_app/data/models/users_search_remote_entity.dart';
import 'package:portafirmas_app/data/models/validate_petitions_list_remote_entity.dart';

abstract class RequestApiContract extends PortafirmaApiBase {
  RequestApiContract({
    required super.dio,
    required super.serverLocalDataSource,
  });

  Future<RequestListRemoteEntity> getRequests({
    required String sessionId,
    required RequestPetitionRemoteEntity petition,
  });

  Future<UserAppListRemoteEntity> getUserRequestApps({
    required String sessionId,
  });

  Future<AppListRemoteEntity> getRequestApps({
    required String sessionId,
    required String publicKeyBase64,
  });

  Future<RequestRemoteEntity> detailRequest({
    required String sessionId,
    required String requestId,
  });

  Future<List<UserRoleRemoteEntity>> getUserRoles({
    required String sessionId,
  });
  Future<List<UsersSearchRemoteEntity>> getUsersBySearch({
    required String sessionId,
    required String name,
    required String mode,
  });

  Future<File> downloadDocument({
    required String sessionId,
    required String documentId,
    required String documentName,
    required int operation,
  });

  Future<RevokeRequestsRemoteEntity> revokeRequests({
    required String sessionId,
    required String encodedReason,
    required String encodedRequestIds,
  });

  Future<ApproveRequestsRemoteEntity> approveRequests({
    required String sessionId,
    required String encodedRequestIds,
  });
  Future<ValidatePetitionsListRemoteEntity> validatePetitions({
    required String sessionId,
    required String petitionId,
  });
}
