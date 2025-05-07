/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

abstract class DocumentLiterals {
  static const annexe = 'ANEXO';
  static const bytes = 'B';
}

abstract class SignReport {
  static const signedFile = '_firmado';
  static const signSuffix = '_firma';
}

abstract class SignDocument {
  static const signedReport = 'report_';
  static const reportSuffix = '_report';
  static const rsaSuffix = 'RSA';
}

abstract class ValidatorAuthorization {
  static const validator = 'validadores';
  static const authorization = 'autorizados';
}

abstract class WebViewLiterals {
  static const sessionCookieName = 'JSESSIONID';
  static const cookie = 'Cookie';
  static const loginSuccessUrl = 'pfmovil/ok.jsp?dni=';
  static const signSuccessUrl = 'pfmovil/ok.jsp?id';
  static const koUrl = 'pfmovil/ko';
  static const errorUrl = '/pfmovil/error.jsp';
  static const transactionId = '&transactionid';
  static const validationError = 'type=validation';
}

abstract class StatusAuthorization {
  static const pendingStatus = 'pending';
}

abstract class AppLiterals {
  static const appName = 'Mi Portafirmas';
  static const notSupportedOperationCode = 'Codigo de operacion no soportado';
  static const proxyVersionUnder25 = 'proxyVersionUnder25';
}

class SignFormats {
  static const pades = 'PADES';
  static const pdf = 'PDF';
  static const cades = 'CADES';

  static const String padesExtension = '.pdf';
  static const String cadesExtension = '.csig';
  static const String xadesExtension = '.xsig';
  static const String techneExtension = '.tcn';
}
