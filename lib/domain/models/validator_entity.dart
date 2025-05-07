
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
import 'package:portafirmas_app/data/models/validator_list_remote_entity.dart';
import 'package:portafirmas_app/domain/models/validator_user_entity.dart';

part 'validator_entity.freezed.dart';

@freezed
class ValidatorEntity with _$ValidatorEntity {
  factory ValidatorEntity({
    required ValidatorUserEntity validatorUser,
    bool? forapps,
  }) = _ValidatorEntity;
}

extension ValidatorRemoteEntityExtension on ValidatorRemoteEntity {
  ValidatorEntity toValidatorEntity() => ValidatorEntity(
        validatorUser: validatorUser.toValidatorUserEntity(),
        forapps: forapps.toLowerCase() == 'true' ? true : false,
      );
}
