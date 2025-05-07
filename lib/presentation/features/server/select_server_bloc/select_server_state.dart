
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'select_server_bloc.dart';

@freezed
class SelectServerState with _$SelectServerState {
  const factory SelectServerState({
    required ServerEntity preSelectedServer,
    required ServerEntity? selectedServerFinal,
    required ScreenStatus serversDataStatus,
    required ScreenStatus serversMigrationDataStatus,
    required ScreenStatus defaultServerStatus,
    required List<ServerEntity> servers,
    @Default(false) isEmmActive,
    @Default(false) isFixedServer,
  }) = _SelectServerState;

  factory SelectServerState.initial() => SelectServerState(
        preSelectedServer: initialServers.first,
        selectedServerFinal: null,
        serversDataStatus: const ScreenStatus.initial(),
        serversMigrationDataStatus: const ScreenStatus.initial(),
        defaultServerStatus: const ScreenStatus.initial(),
        servers: initialServers,
      );
}
