
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/authorization_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/authorizations_list_repository_contract.dart';

class AuthorizationsRepository implements AuthorizationsRepositoryContract {
  final AuthLocalDataSourceContract _authLocalDataSource;
  final AuthorizationRemoteDataSourceContract _authorizationsRemoteDataSource;

  AuthorizationsRepository(
    this._authLocalDataSource,
    this._authorizationsRemoteDataSource,
  );

  @override
  Future<Result<List<AuthDataEntity>>> getAuthorizationsList() async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      } else {
        final res = await _authorizationsRemoteDataSource.getAuthorizationsList(
          sessionId: sessionId,
        );

        return Result.success(res);
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
  Future<Result<bool>> addAuthorization(
    NewAuthorizationUserEntity user,
  ) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      } else {
        await _authorizationsRemoteDataSource.addAuthorization(
          sessionId: sessionId,
          user: user,
        );

        return const Result.success(true);
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
  Future<Result<bool>> revokeAuthorization(
    String authId,
    String operation,
  ) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      await _authorizationsRemoteDataSource.revokeAuthorization(
        sessionId: sessionId,
        authId: authId,
        operation: operation,
      );

      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<bool>> acceptedAuthorization(String authId) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      await _authorizationsRemoteDataSource.acceptAuthorization(
        sessionId: sessionId,
        authId: authId,
      );

      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }
}
