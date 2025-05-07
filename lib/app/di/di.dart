/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:emm/emm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firma_portafirmas/firma_portafirmas.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:portafirmas_app/app/config/environment_config.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/auth_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/certificate_handler_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/migration_android_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/migration_ios_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/pick_file_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/portafirmas_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/push_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/servers_local_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/auth_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/auth_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/authorization_list_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/authorization_list_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/network/dio_http_client.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/network/interceptors/curl_dio_interceptor.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/network/interceptors/mock_interceptor.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/network/interceptors/xml_dio_interceptor.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/push_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/push_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/request_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/request_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/server_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/server_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/sign_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/sign_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/validator_list_api.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/validator_list_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/app_version_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/auth_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/authorization_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/push_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/request_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/server_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/sign_remote_data_source.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/validator_list_remote_data_source.dart';
import 'package:portafirmas_app/data/repositories/app_version_repository.dart';
import 'package:portafirmas_app/data/repositories/auth_repository.dart';
import 'package:portafirmas_app/data/repositories/authorizations_list_repository.dart';
import 'package:portafirmas_app/data/repositories/certificate_repository.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_android_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_ios_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/pick_file_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/portafirmas_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/push_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/app_version_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/auth_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/authorization_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/push_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/request_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/server_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/sign_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/validator_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/migration_repository.dart';
import 'package:portafirmas_app/data/repositories/pick_file_repository.dart';
import 'package:portafirmas_app/data/repositories/push_repository.dart';
import 'package:portafirmas_app/data/repositories/repository_portafirmas.dart';
import 'package:portafirmas_app/data/repositories/request_repository.dart';
import 'package:portafirmas_app/data/repositories/servers_repository.dart';
import 'package:portafirmas_app/data/repositories/sign_repository.dart';
import 'package:portafirmas_app/data/repositories/validator_list_repository.dart';
import 'package:portafirmas_app/domain/repository_contracts/app_version_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/authentication_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/authorizations_list_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/migration_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/pick_file_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/portafirmas_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/push_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/sign_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/change_certificate_ios/change_certificate_bloc/change_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/onboarding/bloc/bloc/onboarding_bloc.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/top_blocs/language_bloc/language_bloc.dart';
import 'package:push_notifications/main.dart';

part 'modules/api_modules.dart';
part 'modules/local_modules.dart';
part 'modules/remote_modules.dart';
part 'modules/repository_modules.dart';
part 'modules/ui_modules.dart';

Future<void> initDi({required FlutterSecureStorage secureStorage}) async {
  _localModulesInit(secureStorage: secureStorage);
  _apiModulesInit();
  _remoteModulesInit();
  _repositoryModulesInit();
  await _uiModulesInit(secureStorage: secureStorage);
}
