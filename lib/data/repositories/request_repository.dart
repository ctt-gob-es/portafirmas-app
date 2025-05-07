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
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/utils/document_utils.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/models/request_filters_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/request_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/data/repositories/models/user_configuration.dart';
import 'package:portafirmas_app/data/repositories/models/user_role.dart';
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/request_list_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';

class RequestRepository implements RequestRepositoryContract {
  final RequestRemoteDataSourceContract _requestRemoteDataSource;
  final AuthLocalDataSourceContract _authLocalDataSource;

  RequestRepository(
    this._requestRemoteDataSource,
    this._authLocalDataSource,
  );

  @override
  Future<Result<RequestListEntity>> getPendingRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  }) {
    return _obtainPendingRequests(
      page: page,
      pageSize: pageSize,
      filter: filter,
      dniValidator: dniValidator,
    );
  }

  @override
  Future<Result<RequestListEntity>> getRejectedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  }) {
    return _obtainRejectedRequests(
      page: page,
      pageSize: pageSize,
      filter: filter,
    );
  }

  @override
  Future<Result<RequestListEntity>> getSignedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  }) {
    return _obtainSignedRequests(
      page: page,
      pageSize: pageSize,
      filter: filter,
    );
  }

  @override
  Future<Result<List<RequestAppData>>> getUserRequestApps() async {
    try {
      String session = await _getSessionId() ?? '';

      if (session.isEmpty) {
        return const Result.failure(error: RepositoryError.authExpired());
      }

      final res = await _requestRemoteDataSource.getUserRequestApps(
        sessionId: session,
      );

      final appList = res.map((e) => e.toRequestAppData()).toList();

      return Result.success(appList);
    } catch (e) {
      return e.toString().contains(AppLiterals.proxyVersionUnder25)
          ? await getAllRequestApps()
          : Result.failure(
              error: RepositoryError.fromDataSourceError(
                NetworkError.fromException(e),
              ),
            );
    }
  }

  @override
  Future<Result<List<RequestAppData>>> getAllRequestApps() async {
    try {
      String session = await _getSessionId() ?? '';
      String publicKeyBase64 =
          await _authLocalDataSource.retrievePublicKey() ?? '';

      if (session.isEmpty || publicKeyBase64.isEmpty) {
        return const Result.failure(error: RepositoryError.authExpired());
      }

      final res = await _requestRemoteDataSource.getAllRequestApps(
        sessionId: session,
        publicKeyBase64: publicKeyBase64,
      );

      final appList = res.map((e) => e.toRequestAppData()).toList();

      return Result.success(appList);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<RequestEntity>> getRequestDetail(String requestId) async {
    try {
      String sessionId = await _getSessionId() ?? '';

      if (sessionId.isEmpty) {
        return const Result.failure(error: RepositoryError.authExpired());
      }
      final data = await _requestRemoteDataSource.detailRequest(
        sessionId: sessionId,
        requestId: requestId,
      );

      return Result.success(data);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<UserConfiguration>> getUserRoles() async {
    try {
      String session = await _getSessionId() ?? '';

      final data =
          await _requestRemoteDataSource.getUserRoles(sessionId: session);

      final List<UserRole> userRoles = data.isNotEmpty
          ? data.map((entity) => entity.toUserRole()).toList()
          : [];

      return Result.success(
        UserConfiguration(proxyVersionUnder25: false, userRoles: userRoles),
      );
    } catch (e) {
      return e.toString().contains(AppLiterals.proxyVersionUnder25)
          ? const Result.success(
              UserConfiguration(proxyVersionUnder25: true, userRoles: []),
            )
          : Result.failure(
              error: RepositoryError.fromDataSourceError(
                NetworkError.fromException(e),
              ),
            );
    }
  }

  @override
  Future<Result<List<UserSearch>>> getUserBySearch(
    String name,
    String mode,
  ) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      } else {
        final res = await _requestRemoteDataSource.getUsersBySearch(
          sessionId: sessionId,
          name: name,
          mode: mode,
        );

        final List<UserSearch> userBySearch =
            res.isNotEmpty ? res.map((e) => e.toUserSearch()).toList() : [];

        return Result.success(userBySearch);
      }
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<String>> getSignedDocument({
    required String docId,
    required String docName,
    required String signFormat,
  }) async {
    docName =
        '$docName${SignReport.signedFile}${DocumentUtils.getSignatureExtension(signFormat)}';

    return _downloadDocument(
      documentId: docId,
      documentName: docName,
      operation: 8,
    );
  }

  @override
  Future<Result<String>> getSignReport({
    required String docId,
    required String docName,
  }) {
    docName = '${SignDocument.signedReport}$docName.pdf';

    return _downloadDocument(
      documentId: docId,
      documentName: docName,
      operation: 9,
    );
  }

  @override
  Future<Result<String>> getDocument({
    required String docId,
    required String docName,
  }) {
    return _downloadDocument(
      documentId: docId,
      documentName: docName,
      operation: 5,
    );
  }

  @override
  Future<Result<List<RevokedRequestEntity>>> revokeRequests({
    required String reason,
    required List<String> requestIds,
  }) async {
    try {
      String sessionId = await _getSessionId() ?? '';

      if (sessionId.isNotEmpty) {
        final res = await _requestRemoteDataSource.revokeRequests(
          sessionId: sessionId,
          reason: reason,
          requestIds: requestIds,
        );

        return Result.success(res);
      } else {
        return Result.failure(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException('Error obtaining session token'),
          ),
        );
      }
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<List<ApprovedRequestEntity>>> approveRequests({
    required List<String> requestIds,
  }) async {
    try {
      String sessionId = await _getSessionId() ?? '';

      if (sessionId.isNotEmpty) {
        final res = await _requestRemoteDataSource.approveRequests(
          sessionId: sessionId,
          requestIds: requestIds,
        );

        return Result.success(res);
      } else {
        return Result.failure(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException('Error obtaining session token'),
          ),
        );
      }
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<List<ValidatePetitionEntity>>> validatePetition({
    required List<String> id,
  }) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId != null) {
        final res = await _requestRemoteDataSource.validatePetitions(
          sessionId: sessionId,
          petitionId: id,
        );

        return Result.success(res);
      } else {
        return Result.failure(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException('Error obtaining session token'),
          ),
        );
      }
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  Future<Result<String>> _downloadDocument({
    required String documentId,
    required String documentName,
    required int operation,
  }) async {
    String sessionId = await _getSessionId() ?? '';
    if (sessionId.isEmpty) {
      const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      final filePath = await _requestRemoteDataSource.downloadDocument(
        sessionId: sessionId,
        documentId: documentId,
        documentName: documentName,
        operation: operation,
      );

      if (_needChangeFileExtension(filePath) && operation == 5) {
        final renamedFile = await _changeFileExtensionToPdf(filePath);

        return Result.success(renamedFile.path);
      } else {
        return Result.success(filePath);
      }
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  Future<File> _changeFileExtensionToPdf(String filePath) {
    final downloadedFile = File(filePath);

    final dotIndex = filePath.lastIndexOf('.');
    final nameWithoutExtension = filePath.substring(0, dotIndex);
    final nameWithExtension = '$nameWithoutExtension.pdf';

    return downloadedFile.rename(nameWithExtension);
  }

  Future<Result<RequestListEntity>> _obtainPendingRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
    String? dniValidator,
  }) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();
      final userNif = await _authLocalDataSource.getUserNif();

      if (sessionId == null || userNif == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      final list = await _requestRemoteDataSource.getRequests(
        sessionId: sessionId,
        petition: RequestPetitionRemoteEntity(
          page: page,
          pageSize: pageSize,
          state: RequestStatus.pending.getFilterKey(),
          filters: RequestFiltersPetitionRemoteEntity.fromRequestFilters(
            filter,
            userNif,
            dniValidator,
          ),
        ),
      );

      return Result.success(list.toRequestListEntity());
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  Future<Result<RequestListEntity>> _obtainSignedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
  }) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();
      final userNif = await _authLocalDataSource.getUserNif();

      if (sessionId == null || userNif == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      final list = await _requestRemoteDataSource.getRequests(
        sessionId: sessionId,
        petition: RequestPetitionRemoteEntity(
          page: page,
          pageSize: pageSize,
          state: RequestStatus.signed.getFilterKey(),
          filters: RequestFiltersPetitionRemoteEntity.fromRequestFilters(
            filter,
            userNif,
            null,
          ),
        ),
      );

      return Result.success(list.toRequestListEntity());
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  Future<Result<RequestListEntity>> _obtainRejectedRequests({
    required int page,
    required int pageSize,
    required RequestFilter filter,
  }) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();
      final userNif = await _authLocalDataSource.getUserNif();

      if (sessionId == null || userNif == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      final list = await _requestRemoteDataSource.getRequests(
        sessionId: sessionId,
        petition: RequestPetitionRemoteEntity(
          page: page,
          pageSize: pageSize,
          state: RequestStatus.rejected.getFilterKey(),
          filters: RequestFiltersPetitionRemoteEntity.fromRequestFilters(
            filter,
            userNif,
            null,
          ),
        ),
      );

      return Result.success(list.toRequestListEntity());
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  Future<String?> _getSessionId() async {
    return await _authLocalDataSource.retrieveSessionId();
  }

  bool _needChangeFileExtension(String filePath) {
    return filePath.endsWith(SignFormats.xadesExtension) ||
        filePath.endsWith(SignFormats.techneExtension);
  }
}
