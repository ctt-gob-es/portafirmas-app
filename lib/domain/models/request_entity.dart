
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
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/date_extensions.dart';
import 'package:portafirmas_app/app/extensions/localizations_extensions.dart';
import 'package:portafirmas_app/app/utils/formate_data.dart';
import 'package:portafirmas_app/app/utils/request_utils.dart';
import 'package:portafirmas_app/domain/models/annexes_entity.dart';
import 'package:portafirmas_app/domain/models/document_entity.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/reject_status.dart';
import 'package:portafirmas_app/domain/models/sign_line_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_type_extension.dart';

part 'request_entity.freezed.dart';

@freezed
class RequestEntity with _$RequestEntity {
  factory RequestEntity({
    required String id,
    required String subject,
    required String from,
    required RequestPriority priority,
    required DateTime lastModificationDate,
    required DateTime? expirationDate,
    required RequestType type,
    @Default(false) bool view,
    String? ref,
    String? application,
    String? signLinesType,
    String? message,
    List<SignLineEntity>? signLines,
    List<DocumentEntity>? listDocs,
    List<AnnexesEntity>? annexesList,
    RejectStatus? rejectStatus,
  }) = _RequestEntity;
}

extension RequestEntityExtension on RequestEntity {
  bool get expiresToday => expirationDate?.isSameDay(DateTime.now()) ?? false;

  String getCardSemantics(
    BuildContext context,
    RequestStatus requestStatus,
    String actionText,
  ) {
    String semantic = '${type.signLabel(context)}.';
    semantic += '$subject. ${context.localizations.detail_subtitle + from}';

    semantic += RequestUtils.subSectionDate(
          context,
          requestStatus,
          this,
        ) ??
        '';
    semantic += '. ';

    if (requestStatus.isPending()) {
      semantic +=
          '${context.localizations.request_data_card_priority}: ${context.localizations.requestPriority(priority)}.';

      semantic +=
          '${context.localizations.request_data_card_last_date}: ${formattedDateYearMonthDay(
        lastModificationDate,
        context.localizations.localeName,
      )}.';

      if (expirationDate != null) {
        semantic +=
            '${context.localizations.request_data_card_expiration_date}: ${formattedDateYearMonthDay(
          expirationDate ?? DateTime(0),
          context.localizations.localeName,
        )}.';
      }
    }

    return '$semantic. $actionText';
  }
}
