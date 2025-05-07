/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of '../di.dart';

final uiModulesDi = GetIt.instance;

Future<void> _uiModulesInit(
    {required FlutterSecureStorage secureStorage}) async {
  final isFirstInstallation = !(await Hive.boxExists('servers'));

  uiModulesDi.registerFactory(
    () => LanguagesBloc(),
  );
  uiModulesDi.registerFactory(
    () => SplashBloc(
      portafirmasRepositoryContract: uiModulesDi(),
      authRepository: uiModulesDi(),
      serversRepositoryContract: uiModulesDi(),
    ),
  );
  uiModulesDi.registerFactory(
    () => OnBoardingBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => AuthBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => FiltersBloc(),
  );
  uiModulesDi.registerFactory(
    () => AppFilterBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => DetailRequestBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => ValidationScreenBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => UsersSearchBloc(
      repositoryContract: uiModulesDi(),
      listRepositoryContract: uiModulesDi(),
    ),
  );
  uiModulesDi.registerFactory(
    () => RequestsBloc(
      requestsRepositoryContract: uiModulesDi(),
      validatorListRepositoryContract: uiModulesDi(),
    ),
  );
  uiModulesDi.registerFactory(
    () => SelectServerBloc(
      serversRepository: uiModulesDi(),
      migrationRepository: uiModulesDi(),
      certificateRepository: uiModulesDi(),
      // We're using Hive to check if there is previous data in app.
      // If there is, this means user come from already opened app or is
      // an updating. If not, this means user is opening the app for the first time.
      // and we need to delete certificate if needed.
      isFromInstallation: isFirstInstallation,
    ),
  );
  uiModulesDi.registerFactory(
    () => ProfileBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => DocumentBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => AuthorizationScreenBloc(repositoryContract: uiModulesDi()),
  );

  uiModulesDi.registerFactory(
    () => AddCertificateBloc(
      fileRepositoryContract: uiModulesDi(),
      certificateRepository: uiModulesDi(),
    ),
  );
  uiModulesDi.registerFactory(
    () => CertificatesHandleBloc(repositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => ChangeCertificateBloc(certificateRepositoryContract: uiModulesDi()),
  );
  uiModulesDi.registerFactory(
    () => PushBloc(pushRepository: uiModulesDi(), secureStorage: secureStorage),
  );
  uiModulesDi.registerFactory(
    () => SignBloc(
      repositoryContract: uiModulesDi(),
      signRepositoryContract: uiModulesDi(),
    ),
  );
  uiModulesDi.registerFactory(() => MultiSelectionRequestBloc());
  uiModulesDi.registerFactory(
    () => AppVersionBloc(repository: uiModulesDi()),
  );
}
