
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
import 'package:portafirmas_app/data/models/app_version_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/app_version_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/app_version_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/app_version_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/app_version/models/version_case.dart';

class AppVersionRepository implements AppVersionRepositoryContract {
  final AppVersionRemoteDataSourceContract _appVersionRemoteDataSource;

  AppVersionRepository(
    this._appVersionRemoteDataSource,
  );

  @override
  Future<Result<AppVersionEntity>> getLatestVersion() async {
    try {
      final data = await _appVersionRemoteDataSource.getAppLatestVersion();

      return Result.success(data.toAppVersionEntity());
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<VersionCase>> getVersionCase() async {
    try {
      late VersionCase caseOfVersion;

      final versionStatus = await _appVersionRemoteDataSource.checkAppVersion();

      // Convert string status from package to VersionCase enum
      switch (versionStatus) {
        case 'Up to date':
          caseOfVersion = VersionCase.upToDate;
          break;
        case 'Update recommended':
          caseOfVersion = VersionCase.updateRecommended;
          break;
        case 'Update required':
          caseOfVersion = VersionCase.updateRequired;
          break;
        default:
          throw Exception('Unknown version status');
      }

      return Result.success(caseOfVersion);
    } catch (e) {
      return const Result.failure(error: RepositoryError.serverError());
    }
  }

  @override
  Future<String> getAppVersion() async {
    final versionStatus =
        await _appVersionRemoteDataSource.getLocalAppVersion();

    return versionStatus['versionApp'];
  }
}
