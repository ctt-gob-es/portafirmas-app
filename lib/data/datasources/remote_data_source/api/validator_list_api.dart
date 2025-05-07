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
import 'package:portafirmas_app/data/models/validator_list_remote_entity.dart';

class ValidatorListApi extends ValidatorListApiContract {
  ValidatorListApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<List<ValidatorRemoteEntity>> getValidatorUserList({
    required String sessionId,
  }) async {
    String xml = '<rqt/>';

    final response = await post(
      operation: 28,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data;

    if (isProxyVersionUnder25(result)) {
      //Proxy version is < 25 so there is no user roles, validators and authorizations
      return [];
    }

    if (!result.containsKey('rsvalidlist')) {
      throw Exception('Error obtaining user validators');
    }

    dynamic valid = result['rsvalidlist']['validlist']['valid'];

    List<dynamic> validatorList = valid == null
        ? []
        : valid is List
            ? valid
            : [valid];

    List<ValidatorRemoteEntity> validators = validatorList.isNotEmpty
        ? validatorList
            .map((validator) => ValidatorRemoteEntity.fromJson(validator))
            .toList()
        : [];

    return validators;
  }

  @override
  Future<RemoveUserRemoteEntity> removeValidatorUser({
    required String sessionId,
    required String validatorId,
  }) async {
    String xml = "<rqrevvalidator id='$validatorId'/>";

    final response = await post(
      operation: 30,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['rs'];

    if (result.containsKey('result')) {
      return RemoveUserRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error trying to delete validator');
    }
  }

  @override
  Future<AddUserRemoteEntity> addValidatorUser({
    required String sessionId,
    required String dni,
    required String id,
    required String name,
  }) async {
    String xml =
        "<rqsavevalid><validator dni='$dni' id='$id'>$name</validator></rqsavevalid>";

    final response = await post(
      operation: 29,
      xmlData: xml,
      sessionCookie: sessionId,
    );

    Map<String, dynamic> result = response.data['rs'];

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('Server error');
    }

    if (result.containsKey('result')) {
      return AddUserRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error trying to add validator');
    }
  }
}
