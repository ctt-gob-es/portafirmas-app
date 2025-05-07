
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/app/config/environment_config.dart';

class AppUrls {
  static String clavePortal = 'https://clave.gob.es/clave_Home/clave.html';
  static String contactFormUrl =
      'https://centrodeservicios.redsara.es/ayuda/consulta/Claveciudadanos';
  static String supportLink =
      'https://centrodeservicios.redsara.es/ayuda/consulta/Portafirmasgeneral';
  static String youtubeChannelLink =
      'https://www.youtube.com/playlist?app=desktop&list=PL46vQDCJl7nN-PB1qQ14v2JRY9O-E9ksn';
  static String inPersonLink =
      'https://clave.gob.es/clave_Home/registro/Como-puedo-registrarme/Registro-avanzado-oficina-registro.html';
  static String frequentlyQuestionsLink = 'https://pf.seap.minhap.es/pf/faq';
  static String policyLink =
      'https://pf.seap.minhap.es/pf/politicas/politicaPrivacidad#Politica_privacidad';
  static String accesibilityLink = 'https://pf.seap.minhap.es/pf/accesibilidad';
  static String legalWarningLink =
      'https://pf.seap.minhap.es/pf/politicas/politicaPrivacidad#Condiciones_uso';
  static String playStoreLink =
      'https://play.google.com/store/apps/details?id=es.gob.afirma.android.signfolder&hl=es_ES';
  static String appleStoreLink =
      'https://apps.apple.com/es/app/portafirmas-firma/id976490515?platform=iphone';

  static String privacyPolicyLink =
      'https://estaticos.redsara.es/appfactory/portafirmas/config/app_config.json';

  static String getUpdateAppUrl() {
    String url = '';
    switch (EnvironmentConfig.environment) {
      case 'test':
      case 'mock':
      case 'dev':
      case 'pre':
        url =
        'https://estaticos.redsara.es/appfactory/portafirmas/config/app_config.json';
        //TODO: set this url when DNS error fixed =>  'https://pre-estaticos.redsara.es/appfactory/portafirmas/config/app_config.json';
        break;
      case 'prod':
        url =
        'https://estaticos.redsara.es/appfactory/portafirmas/config/app_config.json';
        break;
      default:
        url = '';
        break;
    }

    return url;
  }

  static String getUrlUpdateApp(bool isAndroid) {
    return isAndroid ? playStoreLink : appleStoreLink;
  }
}
