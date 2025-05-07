
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

enum OrderFilter { mostRecent, oldest, aboutToExpire }

extension FiltersTitles on OrderFilter {
  String getTitle(BuildContext context) {
    switch (this) {
      case OrderFilter.mostRecent:
        return context.localizations.filters_more_recent_req;
      case OrderFilter.oldest:
        return context.localizations.filters_oldest_req;
      case OrderFilter.aboutToExpire:
        return context.localizations.filters_req_about_to_expire;
    }
  }
}
