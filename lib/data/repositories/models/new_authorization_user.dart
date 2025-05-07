
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

import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';

part 'new_authorization_user.freezed.dart';

@freezed
class NewAuthorizationUser with _$NewAuthorizationUser {
  const factory NewAuthorizationUser({
    required String type,
    required String nif,
    required String id,
    required String observations,
    required String startDate,
    required String expDate,
  }) = _NewAuthorizationUser;
}

extension NewAuthorizationUserExtension on NewAuthorizationUserEntity {
  NewAuthorizationUser toNewAuthorizationUser() => NewAuthorizationUser(
        type: type,
        nif: nif,
        id: id,
        observations: observations,
        startDate: startDate,
        expDate: expDate,
      );
}
