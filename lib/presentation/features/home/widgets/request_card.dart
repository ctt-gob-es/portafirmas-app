
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
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/date_extensions.dart';
import 'package:portafirmas_app/app/extensions/localizations_extensions.dart';
import 'package:portafirmas_app/app/extensions/reject_status_extensions.dart';
import 'package:portafirmas_app/app/theme/colors.dart';
import 'package:portafirmas_app/app/utils/formate_data.dart';
import 'package:portafirmas_app/app/utils/request_utils.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_type_extension.dart';

class RequestCard extends StatelessWidget {
  final RequestEntity requestData;
  final RequestStatus requestStatus;
  final Function() onTap;
  final bool? isSelected;

  const RequestCard({
    super.key,
    required this.requestData,
    required this.onTap,
    required this.requestStatus,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AFTheme.getTheme(
        themeData: AFTheme.defaultTheme.copyWith(
          colors: AppColors.getAppThemeColors().copyWith(
            semanticWarning300: const Color(0xFFFFF1E5),
          ),
          typoOnLight: AFTheme.of(context)
              .typoOnLight
              .copyWith(bodySm: AFTheme.of(context).typoOnLight.bodySmBold),
        ),
      ),
      child: AFDataCard(
        themeComponent:
            requestData.view ? AFThemeComponent.medium : AFThemeComponent.light,
        onTap: onTap,
        header: AFDataCardHeader(
          invertHeader: true,
          text: requestStatus != RequestStatus.pending ||
                  requestData.expirationDate == null
              ? null
              : context.localizations.request_data_card_limit_date(
                  requestData.expirationDate
                          ?.daysOfDifference(DateTime.now()) ??
                      0,
                ),
          label: requestStatus != RequestStatus.validated
              ? requestData.type.label(context)
              : null,
          overrideTextColor: RequestUtils.getHeaderTextColor(
            context,
            requestData.expirationDate?.daysOfDifference(DateTime.now()) ?? 0,
          ),
        ),
        title: AFDataCardTitle(
          title: requestData.subject,
          subtitle: context.localizations.detail_subtitle + requestData.from,
          iconRightAsset: Assets.iconChevronRightBold,
          overrideIconColor: true,
          subSection: RequestUtils.subSectionDate(
            context,
            requestStatus,
            requestData,
          ),
        ),
        data: requestStatus == RequestStatus.pending
            ? AFDataCardData(
                dataEntries: {
                  context.localizations.request_data_card_priority: context
                      .localizations
                      .requestPriority(requestData.priority),
                  context.localizations.request_data_card_last_date:
                      formattedDateYearMonthDay(
                    requestData.lastModificationDate,
                    context.localizations.localeName,
                  ),
                  if (requestData.expirationDate != null) ...{
                    context.localizations.request_data_card_expiration_date:
                        formattedDateYearMonthDay(
                      requestData.expirationDate ?? DateTime(0),
                      context.localizations.localeName,
                    ),
                  },
                },
                overrideFirstEntryValueColor:
                    requestData.priority == RequestPriority.urgent
                        ? AFTheme.of(context).colors.semanticError
                        : null,
              )
            : requestStatus == RequestStatus.rejected
                ? requestData.rejectStatus != null
                    ? AFDataCardData(
                        dataEntries: {
                          context.localizations.request_data_card_status:
                              requestData.rejectStatus
                                      ?.toLocalizedString(context) ??
                                  '',
                        },
                      )
                    : null
                : null,
      ),
    );
  }
}
