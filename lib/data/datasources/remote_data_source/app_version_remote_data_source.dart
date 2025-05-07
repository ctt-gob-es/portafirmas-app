
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863 
*/

import 'package:af_setup/af_setup.dart';
import 'package:portafirmas_app/app/config/environment_config.dart';
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/data/models/app_version_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/app_version_remote_data_source_contract.dart';


// Implementation of the App Version Remote Data Source Contract
class AppVersionRemoteDataSource implements AppVersionRemoteDataSourceContract {
  AppVersionRemoteDataSource();

  @override
  Future<AppVersionRemoteEntity> getAppLatestVersion() async {
    if (EnvironmentConfig.environment != 'mock') {
      final response = await checkServerVersion(AppUrls.getUpdateAppUrl());

      return AppVersionRemoteEntity(
        minAppVersion: response['minAppVersion'],
        warningAppVersion: response['warningAppVersion'],
      );
    } else {
      return const AppVersionRemoteEntity(
        minAppVersion: '0.8.0',
        warningAppVersion: '0.9.0',
      );
    }
  }

  @override
  Future<String> checkAppVersion() async {
    return EnvironmentConfig.environment != 'mock'
        ? await checkAppGoodVersion(AppUrls.getUpdateAppUrl())
        : 'Up to date';
  }

  @override
  Future<Map<String, dynamic>> getLocalAppVersion() async {
    return await getAppVersion();
  }
}
