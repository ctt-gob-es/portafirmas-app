
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

class RoutePath {
  static String splash = '/';
  static String onBoarding = '/onBoarding';
  // Home
  static String home = '/home';
  static String requestsScreen = '$home/requestsScreen';
  static String requestsSignWithClave = '$requestsScreen/signWithClaveScreen';

  // Initial access
  static const String accessScreen = '/accessScreen';

  // Servers
  static String selectServer = '$accessScreen/selectFirstTimeServer';
  static String serverEditionPath = '/edit';
  static String changeServer = '$accessScreen/servers';
  static String changeServerInCertServer = '$serverCertScreen/servers';

  // Authentication
  static String authentication = '$accessScreen/authentication';

  // Certificates
  static String explainAddCert = '$authentication/explainAddCert';
  static String addFirstCertificateSuccess = '$explainAddCert/certAddSuccess';
  static String addFirstCertificateError = '$explainAddCert/certAddError';

  static String serverCertScreen = '$authentication/serverCertScreen';
  static String certificatesListIOS = '$serverCertScreen/certificates';
  static String addNewCertificateSuccess =
      '$certificatesListIOS/certAddSuccess';
  static String addNewCertificateError = '$certificatesListIOS/certAddError';
  static String certificateWarningAndroid =
      '$serverCertScreen/certificateWarning';

  // Detail
  static String detailRequest = '$requestsScreen/detailRequestScreen';
  static String detailSignWithClave = '$detailRequest/signWithClaveScreen';
  static String addressee = '$detailRequest/addresseeScreen';
  static String annexes = '$detailRequest/annexesScreen';
  static String signDetail = '$detailRequest/signDetailScreen';
  static String informSignDetail = '$detailRequest/informSignDetailScreen';

  // Settings
  static String settingsScreen = '$requestsScreen/settingsScreen';
  static String profileScreen = '$settingsScreen/profileScreen';
  static String validationScreen = '$settingsScreen/validationScreen';
  static String validationSearchScreen =
      '$validationScreen/validationSearchScreen';
  static String authorizationScreen = '$settingsScreen/authorizationScreen';
  static String addAuthorizedScreen =
      '$authorizationScreen/addAuthorizedScreen';
  static String authorizationDetailsScreen =
      '$authorizationScreen/authorizationDetailsScreen';
  static String languageScreen = '$settingsScreen/languageScreen';
  static String filtersScreen = '$requestsScreen/filtersScreen';
  static String supportScreen = '$settingsScreen/supportScreen';
}
