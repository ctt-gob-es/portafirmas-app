
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required ScreenStatus screenStatus,
    required List<UserRole> profiles,
    required UserRole? selectedProfile,
    bool? proxyVersionUnder25,
  }) = _ProfileState;

  factory ProfileState.initial() => const ProfileState(
        profiles: [],
        selectedProfile: null,
        screenStatus: ScreenStatus.initial(),
        proxyVersionUnder25: null,
      );
}

extension ProfileStateExtension on ProfileState {
  bool isValidator() => selectedProfile != null;
  bool isProxyVersionUnder25() => proxyVersionUnder25 == true;
}
