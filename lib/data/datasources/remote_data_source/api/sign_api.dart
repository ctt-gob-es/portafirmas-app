/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/sign_api_contract.dart';
import 'package:portafirmas_app/data/models/post_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/post_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';

class SignApi extends SignApiContract {
  SignApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<PreSignRemoteEntity> preSignWithCert({
    required String sessionId,
    required List<SignRequestPetitionRemoteEntity> signReqs,
  }) async {
    String xml = '<rqttri><reqs>';

    for (final SignRequestPetitionRemoteEntity req in signReqs) {
      xml += req.xmlString;
    }
    xml += '</reqs></rqttri>';

    final response = await post(
      operation: 0,
      xmlData: xml,
      sessionCookie: sessionId,
      expectHeader: true,
    );

    Map<String, dynamic> result = response.data;

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('Server error');
    }

    if (result.containsKey('pres') &&
        !result.toString().contains('status: KO')) {
      return PreSignRemoteEntity.fromJson(result['pres']);
    } else {
      throw Exception(
          result['pres']?['req']?['ec'] ?? 'Error presigning requests');
    }
  }

  @override
  Future<PostSignRemoteEntity> postSignWithCert({
    required String sessionId,
    required List<SignRequestPetitionRemoteEntity> signedReqs,
  }) async {
    String xml = '<rqttri><reqs>';

    for (final SignRequestPetitionRemoteEntity req in signedReqs) {
      xml += req.xmlString;
    }
    xml += '</reqs></rqttri>';

    final response = await post(
      operation: 1,
      xmlData: xml,
      sessionCookie: sessionId,
      expectHeader: true,
    );

    Map<String, dynamic> result = response.data;

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('Server error');
    }

    if (result.containsKey('posts') && !result.toString().contains('KO')) {
      return PostSignRemoteEntity.fromJson(result['posts']);
    } else {
      throw Exception(
          result['posts']?['req']?['ec'] ?? 'Error post-signing requests');
    }
  }

  @override
  Future<PreSignClaveRemoteEntity> preSignWithClave({
    required String sessionId,
    required List<String> requestIds,
  }) async {
    String xml = '<rqttri><reqs>';

    for (final String reqId in requestIds) {
      xml += "<req id='$reqId'></req>";
    }
    xml += '</reqs></rqttri>';

    final response = await post(
      operation: 16,
      xmlData: xml,
      sessionCookie: sessionId,
      expectHeader: true,
    );

    Map<String, dynamic> result = response.data;

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('Server error');
    }

    if (result.containsKey('cfrqt')) {
      return PreSignClaveRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error pre-signing requests');
    }
  }

  @override
  Future<PostSignClaveRemoteEntity> postSignWithClave({
    required String sessionId,
  }) async {
    String xml = '<cfrq />';

    final response = await post(
      operation: 17,
      xmlData: xml,
      sessionCookie: sessionId,
      expectHeader: true,
    );

    Map<String, dynamic> result = response.data;

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('Server error');
    }

    if (result.containsKey('cfsig')) {
      return PostSignClaveRemoteEntity.fromJson(result);
    } else {
      throw Exception('Error post-signing requests');
    }
  }
}
