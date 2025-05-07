
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_request_app_remote_entity.freezed.dart';
part 'user_request_app_remote_entity.g.dart';

@freezed
class UserRequestAppRemoteEntity with _$UserRequestAppRemoteEntity {
  const factory UserRequestAppRemoteEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'appName') required String appName,
  }) = _UserRequestAppRemoteEntity;

  factory UserRequestAppRemoteEntity.fromJson(Map<String, dynamic> json) =>
      _$UserRequestAppRemoteEntityFromJson({
        'id': json['ppId']?['\$t'] ?? '0',
        'appName': json['ppName']?['\$t'] ?? '-',
      });
}
