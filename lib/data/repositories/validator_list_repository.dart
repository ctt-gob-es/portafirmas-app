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
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/validator_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/validator_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';

class ValidatorListRepository implements ValidatorListRepositoryContract {
  final ValidatorListRemoteDataSourceContract _validatorListRemoteDataSource;
  final AuthLocalDataSourceContract _authLocalDataSource;

  ValidatorListRepository(
    this._validatorListRemoteDataSource,
    this._authLocalDataSource,
  );

  @override
  Future<Result<List<ValidatorEntity>>> getValidatorUserList() async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      } else {
        final res = await _validatorListRemoteDataSource.getValidatorUserList(
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
  Future<Result<bool>> removeValidatorUser(String validatorId) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      await _validatorListRemoteDataSource.removeValidatorUser(
        sessionId: sessionId,
        validatorId: validatorId,
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
  Future<Result<bool>> addValidatorUser(
    String dni,
    String id,
    String name,
  ) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      await _validatorListRemoteDataSource.addValidatorUser(
        sessionId: sessionId,
        dni: dni,
        id: id,
        name: name,
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
