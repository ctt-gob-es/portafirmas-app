
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
import 'package:portafirmas_app/app/extensions/reject_status_extensions.dart';
import 'package:portafirmas_app/app/utils/formate_data.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/data_entry.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/detail_content_header.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';

class DetailsInfoRequest extends StatelessWidget {
  final DateTime date;
  final DateTime? expiredDate;
  final String reference;
  final String application;
  final RequestStatus status;
  final RequestEntity? requestContent;

  const DetailsInfoRequest({
    super.key,
    required this.date,
    required this.expiredDate,
    required this.reference,
    required this.application,
    required this.status,
    required this.requestContent,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AFCustomContentHeader(
          brightness: AFThemeBrightness.light,
          title: context.localizations.generic_more_details,
          semanticTitle: context.localizations.generic_more_details,
          showLine: true,
          isFixed: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataCardEntry(
                section: context.localizations.generic_init_date,
                data: formatDateYMDH(date, context.localizations.localeName),
              ),
              expiredDate == null
                  ? const SizedBox(
                      height: 0,
                    )
                  : DataCardEntry(
                      section: context.localizations.generic_expired_date,
                      data: formatDateYMDH(
                        expiredDate ?? DateTime(0),
                        context.localizations.localeName,
                      ),
                    ),
              if (status == RequestStatus.rejected &&
                  requestContent?.rejectStatus != null)
                DataCardEntry(
                  section: context.localizations.request_data_card_status,
                  data: requestContent?.rejectStatus
                          ?.toLocalizedString(context) ??
                      '',
                ),
              DataCardEntry(
                section: context.localizations.generic_reference,
                data: reference,
              ),
              DataCardEntry(
                section: context.localizations.generic_application,
                data: application,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
