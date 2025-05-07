
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';

class DocumentUtils {
  static String getSignDocumentName(String name, String signFormat) {
    return '$name${SignReport.signedFile}${getSignatureExtension(signFormat)}';
  }

  static String getSignReportName(String name) {
    return '${SignDocument.signedReport}$name.pdf';
  }

  static String getDocumentFullName(
    String name,
    DocumentType documentType,
    String signFormat,
  ) {
    switch (documentType) {
      case DocumentType.doc:
        return name;
      case DocumentType.signDoc:
        return getSignDocumentName(name, signFormat);
      case DocumentType.signReport:
        return getSignReportName(name);
    }
  }

  static String getSignatureExtension(final String signFormat) {
    String ext;
    switch (signFormat.toUpperCase()) {
      case SignFormats.pades:
      case SignFormats.pdf:
        ext = SignFormats.padesExtension;
        break;
      case SignFormats.cades:
        ext = SignFormats.cadesExtension;
        break;
      default:
        ext = SignFormats.xadesExtension;
        break;
    }

    return ext;
  }
}
