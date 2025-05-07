
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

import 'package:portafirmas_app/app/constants/assets.dart';

enum _ListType {
  emptyPendingRequestValidated,
  emptyPendingRequestNormalWithFilter,
  emptyPendingRequestNormalWithoutFilter,
  emptyRejectedRequests,
  emptySignedRequests,
  emptyValidatedRequests,
  emptySignedAndRejectedRequestsWithFilters,
}

class EmptyRequestList extends StatelessWidget {
  final _ListType _type;
  const EmptyRequestList.emptyPendingRequestValidated({Key? key})
      : _type = _ListType.emptyPendingRequestValidated,
        super(key: key);
  const EmptyRequestList.emptyPendingRequestNormalWithFilter({Key? key})
      : _type = _ListType.emptyPendingRequestNormalWithFilter,
        super(key: key);
  const EmptyRequestList.emptyPendingRequestNormalWithoutFilter({Key? key})
      : _type = _ListType.emptyPendingRequestNormalWithoutFilter,
        super(key: key);
  const EmptyRequestList.emptyRejectedRequests({Key? key})
      : _type = _ListType.emptyRejectedRequests,
        super(key: key);
  const EmptyRequestList.emptySignedRequests({Key? key})
      : _type = _ListType.emptySignedRequests,
        super(key: key);
  const EmptyRequestList.emptyValidatedRequests({Key? key})
      : _type = _ListType.emptyValidatedRequests,
        super(key: key);
  const EmptyRequestList.emptySignedAndRejectedRequestsWithFilters({Key? key})
      : _type = _ListType.emptySignedAndRejectedRequestsWithFilters,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.iconAlertCircle),
          const SizedBox(
            height: 27,
          ),
          Theme(
            data: AFTheme.getTheme(
              themeData: AFTheme.defaultTheme.copyWith(
                typoOnLight: AFTheme.of(context).typoOnLight.copyWith(
                      heading1: AFTheme.of(context).typoOnLight.heading5,
                    ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AFTitle(
                brightness: AFThemeBrightness.light,
                size: AFTitleSize.xxl,
                align: AFTitleAlign.center,
                title: _getTitle(context),
                subTitle: _getSubtitle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(BuildContext context) {
    switch (_type) {
      case _ListType.emptyPendingRequestValidated:
        return context.localizations.empty_pending_request_with_validator_title;
      case _ListType.emptyPendingRequestNormalWithFilter:
      case _ListType.emptyPendingRequestNormalWithoutFilter:
        return context.localizations.empty_pending_request_normal_title;
      case _ListType.emptyRejectedRequests:
        return context.localizations.empty_rejected_request_title;
      case _ListType.emptySignedRequests:
        return context.localizations.empty_signed_request_title;
      case _ListType.emptyValidatedRequests:
        return context.localizations.empty_validated_request_title;
      case _ListType.emptySignedAndRejectedRequestsWithFilters:
        return context
            .localizations.empty_signed_rejected_request_with_filters_title;
    }
  }

  String? _getSubtitle(BuildContext context) {
    switch (_type) {
      case _ListType.emptyPendingRequestValidated:
        return context
            .localizations.empty_pending_request_with_validator_subtitle;
      case _ListType.emptyPendingRequestNormalWithFilter:
        return context.localizations.empty_pending_request_normal_subtitle;
      case _ListType.emptyPendingRequestNormalWithoutFilter:
        return context
            .localizations.empty_pending_request_without_filter_subtitle;
      case _ListType.emptyRejectedRequests:
      case _ListType.emptySignedRequests:
      case _ListType.emptyValidatedRequests:
      case _ListType.emptySignedAndRejectedRequestsWithFilters:
        return null;
    }
  }
}
