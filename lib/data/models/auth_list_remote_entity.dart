
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
import 'package:portafirmas_app/data/models/auth_remote_entity.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/auth_observations_entity.dart';
import 'package:portafirmas_app/domain/models/auth_sender_entity.dart';
import 'package:portafirmas_app/domain/models/authuser_entity.dart';

part 'auth_list_remote_entity.freezed.dart';
part 'auth_list_remote_entity.g.dart';

@freezed
class AuthListRemoteEntity with _$AuthListRemoteEntity {
  const factory AuthListRemoteEntity({
    @JsonKey(name: 'authlist') required AuthRemoteEntity authlist,
  }) = _AuthListRemoteEntity;

  factory AuthListRemoteEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthListRemoteEntityFromJson({
        'authlist': json['authlist'],
      });
}

extension AuthListRemoteEntityExtension on AuthListRemoteEntity {
  List<AuthDataEntity> toAuthDataEntityList() {
    return authlist.auth.map((e) {
      AuthSenderUseEntity userEntity = AuthSenderUseEntity(
        id: e.user.id,
        dni: e.user.dni,
        username: e.user.username,
      );

      AuthUserEntity authuserEntity = AuthUserEntity(
        id: e.authuser.id,
        dni: e.authuser.dni,
        authUsername: e.authuser.authUsername,
      );

      AuthObservationsEntity observationsEntity = AuthObservationsEntity(
        observations: e.observations?.observations,
      );

      return AuthDataEntity(
        user: userEntity,
        authUser: authuserEntity,
        observations: observationsEntity,
        id: e.id,
        type: e.id,
        state: e.state,
        startDate: e.startdate,
        revDate: e.revdate,
        sended: false,
      );
    }).toList();
  }
}
