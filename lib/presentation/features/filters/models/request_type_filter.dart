
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

enum RequestTypeFilter { all, validated, notValidated, sign, approval }

extension FiltersTitles on RequestTypeFilter {
  String getTitle(BuildContext context) {
    switch (this) {
      case RequestTypeFilter.all:
        return context.localizations.filters_all_req;
      case RequestTypeFilter.validated:
        return context.localizations.filters_validated_req;
      case RequestTypeFilter.notValidated:
        return context.localizations.filters_not_validated_req;
      case RequestTypeFilter.sign:
        return context.localizations.filters_sign_req;
      case RequestTypeFilter.approval:
        return context.localizations.filters_approval_req;
    }
  }

  String getChip(BuildContext context) {
    switch (this) {
      case RequestTypeFilter.all:
        return context.localizations.filters_all_req;
      case RequestTypeFilter.validated:
        return context.localizations.validated_tab_text;
      case RequestTypeFilter.notValidated:
        return context.localizations.filters_chip_not_validated;
      case RequestTypeFilter.sign:
        return context.localizations.signature_text;
      case RequestTypeFilter.approval:
        return context.localizations.approval_text;
    }
  }
}
