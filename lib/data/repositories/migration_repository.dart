
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/foundation.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_android_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_ios_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

import 'package:portafirmas_app/domain/repository_contracts/migration_repository_contract.dart';

class MigrationRepository implements MigrationRepositoryContract {
  final MigrationAndroidLocalDataSourceContract migrationAndroid;
  final MigrationIOSLocalDataSourceContract migrationIOS;
  final ServersLocalDataSourceContract serversLocalDatasource;

  MigrationRepository(
    this.migrationAndroid,
    this.migrationIOS,
    this.serversLocalDatasource,
  );

  @override
  Future<Result> migrateServers() async {
    try {
      final servers = defaultTargetPlatform == TargetPlatform.iOS
          ? await migrationIOS.retrieveServers()
          : await migrationAndroid.retrieveServers();

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // If ios set default server if is null
        final defaultServer = await serversLocalDatasource.getDefaultServer();

        if (defaultServer == null) {
          final defaultServer = await migrationIOS.migrateDefaultServer();
          if (defaultServer != null) {
            serversLocalDatasource.setDefaultServer(defaultServer.url);
          }
        }
      }

      if (servers.isNotEmpty) {
        await serversLocalDatasource.addServers(servers);

        return const Result.success('');
      } else {
        return const Result.success('');
      }
    } catch (error) {
      // Return the parsed error
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          error,
        ),
      );
    }
  }

  @override
  Future<Result> migrateDefaultCertificate() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return const Result.success('');
    }

    try {
      await migrationIOS.migrateDefaultCertificate();

      return const Result.success('');
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          error,
        ),
      );
    }
  }
}
