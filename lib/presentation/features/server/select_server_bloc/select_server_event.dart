
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
class SelectServerEvent with _$SelectServerEvent {
  const factory SelectServerEvent.selectServer(ServerEntity serverToSelect) =
      _SelectServer;
  const factory SelectServerEvent.loadServers() = _LoadServers;

  const factory SelectServerEvent.loadMigratedServers() = _LoadMigratedServers;
  const factory SelectServerEvent.setSelectedServerDefault() =
      _SetSelectedServerDefault;

  const factory SelectServerEvent.addServer({
    required String alias,
    required String url,
  }) = _AddServer;
  const factory SelectServerEvent.updateServer({
    required int dbIndex,
    required String alias,
    required String url,
  }) = _UpdateServer;
  const factory SelectServerEvent.deleteServer(int dbIndex) = _DeleteServer;

  const factory SelectServerEvent.changeScreen() = _ChangeScreen;
}
