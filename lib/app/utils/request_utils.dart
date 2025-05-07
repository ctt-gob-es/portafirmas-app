
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';

class RequestUtils {
  static String? subSectionDate(
    BuildContext context,
    RequestStatus requestStatus,
    RequestEntity requestData,
  ) {
    switch (requestStatus) {
      case RequestStatus.pending:
        return null;
      case RequestStatus.signed:
        return context.localizations
            .signed_request_date(requestData.lastModificationDate);
      case RequestStatus.validated:
        return context.localizations
            .validated_request_date(requestData.lastModificationDate);
      case RequestStatus.rejected:
        return context.localizations
            .rejected_request_date(requestData.lastModificationDate);
      default:
        return null;
    }
  }

  static Color? getHeaderTextColor(BuildContext context, int daysCount) {
    switch (daysCount) {
      case 0:
        return AFTheme.of(context).colors.semanticWarning;
      default:
        return AFTheme.of(context).colors.complementary;
    }
  }
}
