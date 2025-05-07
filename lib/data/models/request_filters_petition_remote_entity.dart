
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';

import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';

part 'request_filters_petition_remote_entity.freezed.dart';

@freezed
class RequestFiltersPetitionRemoteEntity
    with _$RequestFiltersPetitionRemoteEntity {
  const factory RequestFiltersPetitionRemoteEntity({
    /// Order, 'asc' to ascendant order, otherwise for descendant order. In order to work, orderAttribute  has to be indicated
    String? orderAscDesc,

    /// Init date of request
    String? initDate,

    /// End date of request
    String? endDate,

    /// Param to order by a column of petition (values: fmodified, dsubject, application, fexpiration)
    String? orderAttribute,

    /// Search the string in each parameter of request
    String? search,

    /// Filter the request by the label
    String? label,

    /// Identifier of an app, filter the request by this application
    String? application,

    /// The dni of the actual user
    String? userId,

    /// Owner id, the dni of the selected role
    String? dniValidator,

    /// 'true' to show unverified, false otherwise
    String? showUnverified,

    /// Month filter of the request (values: all, lastMonth, lastWeek, last24Hours, <number of the month>)
    String? monthFilter,

    /// 'view_all' to get all request,
    /// or 'view_no_validate' to get only not validated request (Typically used when the role is verifier)
    String? type,
  }) = _RequestFiltersPetitionRemoteEntity;

  factory RequestFiltersPetitionRemoteEntity.fromRequestFilters(
    RequestFilter filter,
    String userNif,
    String? dniValidatorFilter,
  ) {
    String? orderAscDesc;
    String? orderAttribute;

    switch (filter.order) {
      case OrderFilter.mostRecent:
        orderAscDesc = 'desc';
        orderAttribute = 'fmodified';
        break;
      case OrderFilter.oldest:
        orderAscDesc = 'asc';
        orderAttribute = 'fmodified';
        break;
      case OrderFilter.aboutToExpire:
        orderAscDesc = 'asc';
        orderAttribute = 'fexpiration';
        break;
    }

    String? type;
    switch (filter.requestType) {
      case RequestTypeFilter.all:
        type = 'view_all';
        break;
      case RequestTypeFilter.validated:
        type = 'view_validate';
        break;
      case RequestTypeFilter.notValidated:
        type = 'view_no_validate';
        break;
      case RequestTypeFilter.sign:
        type = 'view_sign';
        break;
      case RequestTypeFilter.approval:
        type = 'view_pass';
        break;
    }

    String? monthFilter;
    switch (filter.timeInterval) {
      case TimeIntervalFilter.all:
        monthFilter = 'all';
        break;
      case TimeIntervalFilter.last24h:
        monthFilter = 'last24Hours';
        break;
      case TimeIntervalFilter.lastWeek:
        monthFilter = 'lastWeek';
        break;
      case TimeIntervalFilter.lastMonth:
        monthFilter = 'lastMonth';
        break;
    }

    String? search = filter.inputFilter;

    String? application = filter.app?.id;

    return RequestFiltersPetitionRemoteEntity(
      orderAscDesc: orderAscDesc,
      orderAttribute: orderAttribute,
      type: type,
      monthFilter: monthFilter,
      search: search,
      application: application,
      userId: userNif,
      dniValidator: dniValidatorFilter,
    );
  }
}

extension RequestFiltersPetitionRemoteEntityExtension
    on RequestFiltersPetitionRemoteEntity {
  String get xmlString {
    String result = '<fltrs>';
    Map<String, String?> allFiltersMap = {
      'orderAscDesc': orderAscDesc,
      'initDateFilter': initDate,
      'endDateFilter': endDate,
      'orderAttribute': orderAttribute,
      'searchFilter': search,
      'labelFilter': label,
      'applicationFilter': application,
      'userId': userId,
      'dniValidadorFilter': dniValidator,
      'showUnverified': showUnverified,
      'mesFilter': monthFilter,
      'tipoFilter': type,
    };

    for (final entry in allFiltersMap.entries) {
      if (entry.value != null) {
        result +=
            '<fltr><key>${entry.key}</key><value>${entry.value}</value></fltr>';
      }
    }

    result += '</fltrs>';

    return result;
  }
}
