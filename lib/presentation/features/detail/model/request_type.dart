
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/domain/models/annexes_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SignatureType { fall, parallel }

SignatureType getSignatureType(String signature) {
  switch (signature) {
    case 'CASCADA':
      return SignatureType.fall;
    default:
      return SignatureType.parallel;
  }
}

List<AnnexesEntity> getAnnexesList(
  List<AnnexesEntity> annexesList,
) {
  return annexesList.toList();
}

extension DetailRequestContext on AppLocalizations {
  String requestTypeSignHeader(String status) {
    switch (status) {
      case 'CASCADA':
        return addressee_fall_header;
      default:
        return addressee_parallel_header;
    }
  }

  String requestTypeSignTitle(String status) {
    switch (status) {
      case 'CASCADA':
        return addressee_fall_title;
      default:
        return addressee_parallel_title;
    }
  }
}
