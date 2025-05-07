
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/validator_list_api_contract.dart';
import 'package:portafirmas_app/data/models/add_validator_remote_entity.dart';
import 'package:portafirmas_app/data/models/remove_validator_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/validator_list_remote_data_source_contract.dart';

import 'package:portafirmas_app/domain/models/validator_entity.dart';

class ValidatorListRemoteDataSource
    implements ValidatorListRemoteDataSourceContract {
  final ValidatorListApiContract _api;

  ValidatorListRemoteDataSource(this._api);
  @override
  Future<List<ValidatorEntity>> getValidatorUserList({
    required String sessionId,
  }) async {
    final result = await _api.getValidatorUserList(
      sessionId: sessionId,
    );

    final List<ValidatorEntity> validatorList = result.isNotEmpty
        ? result.map((val) => val.toValidatorEntity()).toList()
        : [];

    return validatorList;
  }

  @override
  Future<RemoveUserRemoteEntity> removeValidatorUser({
    required String sessionId,
    required String validatorId,
  }) {
    return _api.removeValidatorUser(
      sessionId: sessionId,
      validatorId: validatorId,
    );
  }

  @override
  Future<AddUserRemoteEntity> addValidatorUser({
    required String sessionId,
    required String dni,
    required String id,
    required String name,
  }) {
    return _api.addValidatorUser(
      sessionId: sessionId,
      dni: dni,
      id: id,
      name: name,
    );
  }
}
