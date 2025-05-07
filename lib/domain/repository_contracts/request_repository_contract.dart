
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/data/repositories/models/user_configuration.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';

import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/domain/models/request_list_entity.dart';

import 'package:portafirmas_app/data/repositories/models/user_search.dart';

typedef GetRequest = Future<Result<RequestListEntity>> Function({
  required int page,
  required int pageSize,
  required RequestFilter filter,
  @Default(null) String? dniValidator,
});

abstract class RequestRepositoryContract {
  Future<Result<RequestListEntity>> getPendingRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  });
  Future<Result<RequestListEntity>> getSignedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  });
  Future<Result<RequestListEntity>> getRejectedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  });
  Future<Result<List<RequestAppData>>> getUserRequestApps();
  Future<Result<List<RequestAppData>>> getAllRequestApps();
  Future<Result<RequestEntity>> getRequestDetail(String requestId);
  Future<Result<UserConfiguration>> getUserRoles();
  Future<Result<List<UserSearch>>> getUserBySearch(String name, String mode);
  Future<Result<String>> getSignedDocument({
    required String docId,
    required String docName,
    required String signFormat,
  });
  Future<Result<String>> getSignReport({
    required String docId,
    required String docName,
  });
  Future<Result<String>> getDocument({
    required String docId,
    required String docName,
  });
  Future<Result<List<RevokedRequestEntity>>> revokeRequests({
    required String reason,
    required List<String> requestIds,
  });
  Future<Result<List<ApprovedRequestEntity>>> approveRequests({
    required List<String> requestIds,
  });
  Future<Result<List<ValidatePetitionEntity>>> validatePetition({
    required List<String> id,
  });
}
