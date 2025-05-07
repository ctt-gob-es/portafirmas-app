
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';

part 'filters_event.dart';
part 'filters_state.dart';
part 'filters_bloc.freezed.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  FiltersBloc() : super(FiltersState.initial()) {
    on<FiltersEvent>((event, emit) async {
      event.when(
        initFilters: (filters) {
          emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
          emit(
            state.copyWith(
              temporalFilters: filters ?? RequestFilter.initial(),
              screenStatus: const ScreenStatus.success(),
            ),
          );
        },
        selectedOrderFilter: (OrderFilter orderFilter) {
          emit(state.copyWith(
            temporalFilters: state.temporalFilters.copyWith(order: orderFilter),
          ));
        },
        selectedRequestTypeFilter: (RequestTypeFilter requestTypeFilter) {
          emit(state.copyWith(
            temporalFilters:
                state.temporalFilters.copyWith(requestType: requestTypeFilter),
          ));
        },
        selectedTimeIntervalFilter: (TimeIntervalFilter timeIntervalFilter) {
          emit(state.copyWith(
            temporalFilters: state.temporalFilters
                .copyWith(timeInterval: timeIntervalFilter),
          ));
        },
        selectedAppFilter: (selectedApp) {
          emit(state.copyWith(
            temporalFilters: state.temporalFilters.copyWith(app: selectedApp),
          ));
        },
        updatedInputFilter: (inputFilter) {
          emit(
            state.copyWith(
              temporalFilters:
                  state.temporalFilters.copyWith(inputFilter: inputFilter),
            ),
          );
        },
        resetFilters: (hasValidators) async {
          emit(state.copyWith(
            screenStatus: const ScreenStatus.loading(),
          ));
          await Future.delayed(const Duration(milliseconds: 500));
          add(
            FiltersEvent.initFilters(
              initFilters: hasValidators
                  ? RequestFilter.validated()
                  : RequestFilter.initial(),
            ),
          );
        },
      );
    });
  }
}
