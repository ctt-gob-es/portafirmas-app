
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
import 'package:portafirmas_app/data/models/auth_data_remote_entity.dart';
import 'package:portafirmas_app/domain/models/auth_observations_entity.dart';
import 'package:portafirmas_app/domain/models/auth_sender_entity.dart';
import 'package:portafirmas_app/domain/models/authuser_entity.dart';

part 'auth_data_entity.freezed.dart';

@freezed
class AuthDataEntity with _$AuthDataEntity {
  factory AuthDataEntity({
    AuthSenderUseEntity? user,
    required AuthUserEntity authUser,
    AuthObservationsEntity? observations,
    String? id,
    required String type,
    String? state,
    required String startDate,
    String? revDate,
    bool? sended,
  }) = _AuthDataEntity;
}

extension AuthDataRemoteEntityExtension on AuthDataRemoteEntity {
  AuthDataEntity toAuthDataEntity() => AuthDataEntity(
        user: user.toAuthSenderUserEntity(),
        authUser: authuser.toAuthUserEntity(),
        observations: observations?.toObservationsEntity(),
        id: id,
        type: type,
        state: state,
        startDate: startdate,
        revDate: revdate,
        sended: sended?.toLowerCase() == 'true' ? true : false,
      );
}
