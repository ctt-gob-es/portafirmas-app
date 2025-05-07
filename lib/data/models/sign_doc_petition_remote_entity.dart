
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
import 'package:portafirmas_app/presentation/features/detail/model/sign_data.dart';

part 'sign_doc_petition_remote_entity.freezed.dart';

@freezed
class SignDocPetitionRemoteEntity with _$SignDocPetitionRemoteEntity {
  const factory SignDocPetitionRemoteEntity({
    //document id
    required String docId,
    //format of sign
    required String signFrmt,
    //algorithm of sign
    required String signAlgo,
    //params of sign
    required String params,
    //(optional) code of sign operation => (sign, cosign, countersign)
    String? cop,
    //obtained from Pre sign (only for post sign)
    bool? needCnf,
    //sign result (only for post sign)
    SignData? signResult,
  }) = _SignDocPetitionRemoteEntity;
}

extension SignDocPetitionRemoteEntityExtension on SignDocPetitionRemoteEntity {
  String get xmlString =>
      "<doc docid='$docId'${_getCop()} sigfrmt='$signFrmt' mdalgo='$signAlgo'${_getNeedCnf()}><params>$params</params>${signResult?.xmlString ?? ''}</doc>";

  String _getCop() => cop != null ? " cop='$cop'" : '';

  String _getNeedCnf() => needCnf != null ? " needcnf='$needCnf'" : '';
}
