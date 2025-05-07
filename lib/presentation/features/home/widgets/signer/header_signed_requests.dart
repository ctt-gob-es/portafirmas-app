
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/theme/fonts.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';

class HeaderSignedRequests extends StatelessWidget {
  final int requestCount;
  final bool hasFilters;
  const HeaderSignedRequests({
    Key? key,
    required this.requestCount,
    required this.hasFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Filters
        const FilterChipsBox(
          requestStatus: RequestStatus.signed,
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 24),
          alignment: Alignment.centerLeft,
          child: Text(
            hasFilters
                ? context.localizations.request_list_title_found(requestCount)
                : context.localizations.signed_request_list_title(requestCount),
            style: AFTheme.of(context)
                .typoOnLight
                .heading6
                .copyWith(fontFamily: AppFonts.fontFamily, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
