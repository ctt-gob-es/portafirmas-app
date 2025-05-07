
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
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
part 'request_filter.freezed.dart';

@freezed
class RequestFilter with _$RequestFilter {
  const factory RequestFilter({
    required OrderFilter order,
    required RequestTypeFilter requestType,
    required TimeIntervalFilter timeInterval,
    required String? inputFilter,
    required RequestAppData? app,
  }) = _RequestFilter;

  factory RequestFilter.initial() => const RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.all,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: null,
        app: null,
      );

  factory RequestFilter.validated() => const RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.validated,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: null,
        app: null,
      );
  factory RequestFilter.notValidated() => const RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.notValidated,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: null,
        app: null,
      );
}
