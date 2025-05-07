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
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/server_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';

class ServersRepository implements ServersRepositoryContract {
  final ServersLocalDataSourceContract _serversLocalDataSourceContract;
  final ServerRemoteDataSourceContract _serverRemoteDataSourceContract;

  ServersRepository(
    this._serversLocalDataSourceContract,
    this._serverRemoteDataSourceContract,
  );

  @override
  Future<Result<ServerEntity?>> getEmmServer() async {
    return Result.success(await _serverRemoteDataSourceContract.getEmmServer());
  }

  @override
  Future<Result<String?>> getDefaultServer() async {
    try {
      final data = await _serversLocalDataSourceContract.getDefaultServer();

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
  Future<Result<void>> setDefaultServer(ServerEntity server) async {
    try {
      final data =
          await _serversLocalDataSourceContract.setDefaultServer(server.url);

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
  Future<Result<List<ServerEntity>>> getServers() async {
    try {
      final data = await _serversLocalDataSourceContract.getServers();

      return Result.success(data.map((e) => e.toServerEntity()).toList());
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<ServerEntity>> addServer(String alias, String url) async {
    try {
      final isValid =
          await _serverRemoteDataSourceContract.isAValidServer(url: url);

      if (isValid) {
        final index = await _serversLocalDataSourceContract.addServer(
          alias,
          url,
        );

        return Result.success(
          ServerEntity(databaseIndex: index, alias: alias, url: url),
        );
      }

      return const Result.failure(error: RepositoryError.badRequest());
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<ServerEntity>> modifyServer(
    int index,
    String alias,
    String url,
  ) async {
    try {
      final isValid =
          await _serverRemoteDataSourceContract.isAValidServer(url: url);

      if (isValid) {
        await _serversLocalDataSourceContract.modifyServer(
          index,
          alias,
          url,
        );

        return Result.success(
          ServerEntity(databaseIndex: index, alias: alias, url: url),
        );
      }

      return const Result.failure(error: RepositoryError.badRequest());
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteServer(int index) async {
    try {
      final data = await _serversLocalDataSourceContract.deleteServer(index);

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
  Future<Result<bool>> getServersMigrated() async {
    try {
      final data = await _serversLocalDataSourceContract.getServersMigrated();

      // Return the result mapped
      return Result.success(data);
    } catch (error) {
      // Return the parsed error
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<void>> setServersMigrated() async {
    try {
      final data = await _serversLocalDataSourceContract.setServersMigrated();

      return Result.success(data);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }
}
