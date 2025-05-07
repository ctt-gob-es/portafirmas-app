
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
import 'package:portafirmas_app/data/models/auth_observations_remote_entity.dart';
import 'package:portafirmas_app/data/models/auth_sender_user_remote_entity.dart';
import 'package:portafirmas_app/data/models/authuser_remote_entity.dart';

part 'auth_data_remote_entity.freezed.dart';
part 'auth_data_remote_entity.g.dart';

@freezed
class AuthDataRemoteEntity with _$AuthDataRemoteEntity {
  const factory AuthDataRemoteEntity({
    @JsonKey(name: 'user') required AuthSenderUserRemoteEntity user,
    @JsonKey(name: 'authuser') required AuthUserRemoteEntity authuser,
    @JsonKey(name: 'observations') AuthObservationsRemoteEntity? observations,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'state') required String state,
    @JsonKey(name: 'startdate') required String startdate,
    @JsonKey(name: 'revdate') String? revdate,
    @JsonKey(name: 'sended') String? sended,
  }) = _AuthDataRemoteEntity;

  factory AuthDataRemoteEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthDataRemoteEntityFromJson({
        'user': json['user'],
        'authuser': json['authuser'],
        'observations': json['observations'],
        'id': json['id'],
        'type': json['type'],
        'state': json['state'],
        'startdate': json['startdate'],
        'revdate': json['revdate'],
        'sended': json['sended'],
      });
}
