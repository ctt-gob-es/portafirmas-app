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

import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/request_api_contract.dart';
import 'package:portafirmas_app/data/models/app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/approved_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_role_remote_entity.dart';
import 'package:portafirmas_app/data/models/users_search_remote_entity.dart';
import 'package:portafirmas_app/data/models/validate_petitions_list_remote_entity.dart';

class RequestApi extends RequestApiContract {
  RequestApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<RequestListRemoteEntity> getRequests({
    required String sessionId,
    required RequestPetitionRemoteEntity petition,
  }) async {
    final String xml = petition.xmlString;
    final response = await post(
      operation: 2,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    return RequestListRemoteEntity.fromJson(result);
  }

  @override
  Future<AppListRemoteEntity> getRequestApps({
    required String sessionId,
    required String publicKeyBase64,
  }) async {
    String xml = '<rqtconf><cert>$publicKeyBase64</cert></rqtconf>';
    final response = await post(
      operation: 6,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (result.containsKey('appConf')) {
      return AppListRemoteEntity.fromJson(result['appConf']);
    } else {
      throw Exception('Error obtaining app list');
    }
  }

  @override
  Future<UserAppListRemoteEntity> getUserRequestApps({
    required String sessionId,
  }) async {
    final response = await post(
      operation: 18,
      xmlData: '<rqsrcnfg />',
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (isProxyVersionUnder25(result)) {
      //Proxy version is < 25 so there is no user roles, validators and authorizations
      throw (Exception(AppLiterals.proxyVersionUnder25));
    }

    if (!result.containsKey('rsgtsrcg')) {
      throw (Exception('Error obtaining app list'));
    }

    final data = result['rsgtsrcg']?['fltrs']?['pps'];

    if (data != null) {
      return UserAppListRemoteEntity.fromJson(data);
    } else {
      throw (Exception('Error obtaining app list'));
    }
  }

  @override
  Future<RequestRemoteEntity> detailRequest({
    required String sessionId,
    required String requestId,
  }) async {
    var xml = "<rqtdtl id='$requestId'></rqtdtl>";
    final response = await post(
      operation: 4,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['dtl'];

    if (result.containsKey('snders')) {
      return RequestRemoteEntity.fromRequestDetail(result);
    } else {
      throw (Exception('Error obtaining detail request'));
    }
  }

  @override
  Future<List<UserRoleRemoteEntity>> getUserRoles({
    required String sessionId,
  }) async {
    final response = await post(
      operation: 18,
      xmlData: '<rqsrcnfg />',
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (isProxyVersionUnder25(result)) {
      //Proxy version is < 25 so there is no user roles, validators and authorizations
      throw (Exception(AppLiterals.proxyVersionUnder25));
    }

    if (!result.containsKey('rsgtsrcg')) {
      throw (Exception('Error obtaining user roles'));
    }

    final data = result['rsgtsrcg']?['rls']?['role'];

    List<dynamic> rolesData = data == null
        ? []
        : data is List
            ? data
            : [data];

    List<UserRoleRemoteEntity> roles = rolesData.isNotEmpty
        ? rolesData
            .map((roleData) => UserRoleRemoteEntity.fromJson(roleData))
            .toList()
        : [];

    return roles;
  }

  @override
  Future<List<UsersSearchRemoteEntity>> getUsersBySearch({
    required String sessionId,
    required String name,
    required String mode,
  }) async {
    String xml = "<rqfinduser mode='$mode'>$name</rqfinduser>";

    final response = await post(
      operation: 19,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (!result.containsKey('rsfinduser')) {
      throw Exception('Error trying to find users');
    }

    final user = result['rsfinduser']['users']['user'];

    List<dynamic> usersList = user == null
        ? []
        : user is List
            ? user
            : [user];

    List<UsersSearchRemoteEntity> usersBySearch = usersList.isNotEmpty
        ? usersList.map((e) => UsersSearchRemoteEntity.fromJson(e)).toList()
        : [];

    return usersBySearch;
  }

  @override
  Future<File> downloadDocument({
    required String sessionId,
    required String documentId,
    required String documentName,
    required int operation,
  }) async {
    String xml = "<rqtprw docid='$documentId'></rqtprw>";

    final savePath = await download(
      operation: operation,
      xmlData: xml,
      documentName: documentName,
      sessionId: sessionId,
    );

    return File(savePath);
  }

  @override
  Future<RevokeRequestsRemoteEntity> revokeRequests({
    required String sessionId,
    required String encodedReason,
    required String encodedRequestIds,
  }) async {
    var xml =
        '<reqrjcts><rsn>$encodedReason</rsn><rjcts>$encodedRequestIds</rjcts></reqrjcts>';

    final response = await post(
      operation: 3,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (result.containsKey('rjcts')) {
      return RevokeRequestsRemoteEntity.fromJson(result);
    } else {
      throw (Exception('Error revoking requests'));
    }
  }

  @override
  Future<ValidatePetitionsListRemoteEntity> validatePetitions({
    required String sessionId,
    required String petitionId,
  }) async {
    var xml = '<verfreq><reqs>$petitionId</reqs></verfreq>';
    final response = await post(
      operation: 20,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (result.containsKey('verifrp')) {
      return ValidatePetitionsListRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error trying to validate petition');
    }
  }

  @override
  Future<ApproveRequestsRemoteEntity> approveRequests({
    required String sessionId,
    required String encodedRequestIds,
  }) async {
    var xml = '<apprv><reqs>$encodedRequestIds</reqs></apprv>';

    final response = await post(
      operation: 7,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (result.containsKey('apprq')) {
      return ApproveRequestsRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error approving requests');
    }
  }
}
