
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';
import 'package:portafirmas_app/data/models/post_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/post_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';

abstract class SignApiContract extends PortafirmaApiBase {
  SignApiContract({
    required super.dio,
    required super.serverLocalDataSource,
  });

  Future<PreSignRemoteEntity> preSignWithCert({
    required String sessionId,
    required List<SignRequestPetitionRemoteEntity> signReqs,
  });
  Future<PostSignRemoteEntity> postSignWithCert({
    required String sessionId,
    required List<SignRequestPetitionRemoteEntity> signedReqs,
  });
  Future<PreSignClaveRemoteEntity> preSignWithClave({
    required String sessionId,
    required List<String> requestIds,
  });
  Future<PostSignClaveRemoteEntity> postSignWithClave({
    required String sessionId,
  });
}
