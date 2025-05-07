
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'app_version_bloc.dart';

@freezed
class AppVersionState with _$AppVersionState {
  const factory AppVersionState.init() = _InitCheckVersionState;
  const factory AppVersionState.loading() = _LoadingCheckVersionState;
  const factory AppVersionState.recommendedUpdateVersion({
    required String appVersion,
  }) = _RecommendedUpdateState;
  const factory AppVersionState.requiredUpdateVersion({
    required String appVersion,
    required String minVersion,
  }) = _RequiredUpdateState;
  const factory AppVersionState.upToDateVersion({
    required String appVersion,
  }) = _UpToDateVersionState;
  const factory AppVersionState.error() = _Error;
}

extension AppVersionStateExtesion on AppVersionState {
  String getVersion() {
    return maybeWhen(
      recommendedUpdateVersion: (appVersion) => appVersion,
      requiredUpdateVersion: (appVersion, _) => appVersion,
      upToDateVersion: (appVersion) => appVersion,
      orElse: () => '0.0.0',
    );
  }
}
