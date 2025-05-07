
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:async';

import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';
import 'package:portafirmas_app/data/models/add_validator_remote_entity.dart';
import 'package:portafirmas_app/data/models/remove_validator_remote_entity.dart';
import 'package:portafirmas_app/data/models/validator_list_remote_entity.dart';

abstract class ValidatorListApiContract extends PortafirmaApiBase {
  ValidatorListApiContract({
    required super.dio,
    required super.serverLocalDataSource,
  });
  Future<List<ValidatorRemoteEntity>> getValidatorUserList({
    required String sessionId,
  });

  Future<RemoveUserRemoteEntity> removeValidatorUser({
    required String sessionId,
    required String validatorId,
  });

  Future<AddUserRemoteEntity> addValidatorUser({
    required String sessionId,
    required String dni,
    required String id,
    required String name,
  });
}
