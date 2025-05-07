
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:convert';

import 'package:portafirmas_app/data/datasources/remote_data_source/api/request_api_contract.dart';
import 'package:portafirmas_app/data/models/request_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/request_remote_data_source_contract.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/request_app_entity.dart';

import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/user_role_entity.dart';
import 'package:portafirmas_app/domain/models/users_search_entity.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';

class RequestRemoteDataSource implements RequestRemoteDataSourceContract {
  final RequestApiContract _api;

  RequestRemoteDataSource(this._api);

  @override
  Future<RequestListRemoteEntity> getRequests({
    required String sessionId,
    required RequestPetitionRemoteEntity petition,
  }) {
    return _api.getRequests(sessionId: sessionId, petition: petition);
  }

  @override
  Future<List<RequestAppEntity>> getUserRequestApps({
    required String sessionId,
  }) async {
    final res = await _api.getUserRequestApps(
      sessionId: sessionId,
    );

    final appListRemote =
        res.userAppList.map((e) => e.toRequestAppEntity()).toList();

    return appListRemote;
  }

  @override
  Future<List<RequestAppEntity>> getAllRequestApps({
    required String sessionId,
    required String publicKeyBase64,
  }) async {
    final res = await _api.getRequestApps(
      sessionId: sessionId,
      publicKeyBase64: publicKeyBase64,
    );

    final appListRemote =
        res.appList.map((e) => e.toRequestAppEntity()).toList();

    return appListRemote;
  }

  @override
  Future<RequestEntity> detailRequest({
    required String sessionId,
    required String requestId,
  }) async {
    final res = await _api.detailRequest(
      sessionId: sessionId,
      requestId: requestId,
    );

    return res.toDetailRequestEntity();
  }

  @override
  Future<List<UserRoleEntity>> getUserRoles({
    required String sessionId,
  }) async {
    final response = await _api.getUserRoles(
      sessionId: sessionId,
    );

    final List<UserRoleEntity> userRoles = response.isNotEmpty
        ? response
            .map((remoteEntity) => remoteEntity.toUserRoleEntity())
            .toList()
        : [];

    return userRoles;
  }

  @override
  Future<List<UsersSearchEntity>> getUsersBySearch({
    required String sessionId,
    required String name,
    required String mode,
  }) async {
    final result = await _api.getUsersBySearch(
      sessionId: sessionId,
      name: name,
      mode: mode,
    );

    final List<UsersSearchEntity> userBySearch = result.isNotEmpty
        ? result.map((e) => e.toUsersSearchEntity()).toList()
        : [];

    return userBySearch;
  }

  @override
  Future<String> downloadDocument({
    required String sessionId,
    required String documentId,
    required String documentName,
    required int operation,
  }) async {
    final response = await _api.downloadDocument(
      sessionId: sessionId,
      documentId: documentId,
      documentName: documentName,
      operation: operation,
    );

    return response.path;
  }

  @override
  Future<List<RevokedRequestEntity>> revokeRequests({
    required String sessionId,
    required String reason,
    required List<String> requestIds,
  }) async {
    var encodedReason = base64Encode(
      reason.codeUnits,
    ).replaceAll('+', '-').replaceAll('/', '_');

    var encodedRequestIds = '';
    for (var element in requestIds) {
      encodedRequestIds += "<rjct id='$element'/>";
    }

    final response = await _api.revokeRequests(
      sessionId: sessionId,
      encodedReason: encodedReason,
      encodedRequestIds: encodedRequestIds,
    );

    return response.revokedRequests
        .map((e) => e.toRevokedRequestEntity())
        .toList();
  }

  @override
  Future<List<ValidatePetitionEntity>> validatePetitions({
    required String sessionId,
    required List<String> petitionId,
  }) async {
    var petitionsIds = '';
    for (var element in petitionId) {
      petitionsIds += "<r id='$element'/>";
    }
    final response = await _api.validatePetitions(
      sessionId: sessionId,
      petitionId: petitionsIds,
    );

    return response.validatePetitions
        .map((e) => e.toValidatePetitionEntity())
        .toList();
  }

  @override
  Future<List<ApprovedRequestEntity>> approveRequests({
    required String sessionId,
    required List<String> requestIds,
  }) async {
    var encodedRequestIds = '';
    for (var element in requestIds) {
      encodedRequestIds += "<rjct id='$element'/>";
    }

    final response = await _api.approveRequests(
      sessionId: sessionId,
      encodedRequestIds: encodedRequestIds,
    );

    return response.approvedRequest
        .map((e) => e.toApprovedRequestEntity())
        .toList();
  }
}
