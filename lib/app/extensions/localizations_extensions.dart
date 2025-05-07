
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:portafirmas_app/domain/models/certificate_usages_enum.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';

extension LocalizationsExtension on AppLocalizations {
  String requestType(RequestType type) {
    switch (type) {
      case RequestType.signature:
        return signature_text;
      case RequestType.approval:
        return approval_text;
    }
  }

  String requestPriority(RequestPriority priority) {
    switch (priority) {
      case RequestPriority.normal:
        return normal_text;
      case RequestPriority.high:
        return high_text;
      case RequestPriority.veryHigh:
        return very_high_text;
      case RequestPriority.urgent:
        return urgent_text;
    }
  }

  String defaultServerName(ServerEntity entity) {
    switch (entity.alias) {
      case 'DefaultGeneralServer':
        return server_default_general_title;
      case 'DefaultRedSaraServer':
        return server_default_redsara_title;
//TODO: Remove this case when PROD is ready
      case 'PreRedSaraServer':
        return 'Pre RedSara';
      default:
        return '';
    }
  }

  String defaultServerSubtitle(ServerEntity entity) {
    switch (entity.alias) {
      case 'DefaultGeneralServer':
        return server_default_general_subtitle;
      case 'DefaultRedSaraServer':
        return server_default_redsara_subtitle;
//TODO: Remove this case when PROD is ready
      case 'PreRedSaraServer':
        return 'Pre RedSara test server';
      default:
        return '';
    }
  }

  String certificateUsages(List<CertificateUsageEnum> usages) {
    String usagesText = '';

    for (int i = 0; i < usages.length; i++) {
      final usage = usages[i];
      switch (usage) {
        case CertificateUsageEnum.sign:
          usagesText += cert_usage_signing;
          break;
        case CertificateUsageEnum.authentication:
          usagesText += cert_usage_authentication;
          break;
        case CertificateUsageEnum.encrypt:
          usagesText += cert_usage_encryption;
          break;
      }
      if (i + 1 < usages.length) {
        usagesText = '$usagesText, ';
      }
    }

    return cert_usage_label(usagesText);
  }
}
