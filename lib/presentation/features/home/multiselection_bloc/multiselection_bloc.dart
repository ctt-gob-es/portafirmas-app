
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
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_type_extension.dart';

part 'multiselection_event.dart';
part 'multiselection_state.dart';
part 'multiselection_bloc.freezed.dart';

class MultiSelectionRequestBloc
    extends Bloc<MultiSelectionRequestEvent, MultiSelectionRequestState> {
  MultiSelectionRequestBloc() : super(MultiSelectionRequestState.initial()) {
    on<MultiSelectionRequestEvent>((event, emit) {
      event.when(
        showCheckbox: (showCheckbox) =>
            emit(state.copyWith(showCheckbox: showCheckbox)),
        isCheckBoxSelected: (isSelected, request) =>
            isCheckBoxSelected(emit, request, isSelected),
        initialState: () => emit(MultiSelectionRequestState.initial()),
        selectAllRequests: (selectAll, requestsList) =>
            selectAllRequests(emit, selectAll, requestsList),
      );
    });
  }

  void selectAllRequests(
    Emitter emit,
    bool selectAll,
    List<RequestEntity> requestsList,
  ) {
    final localRequests = <RequestEntity, bool>{};

    if (selectAll) {
      for (var request in requestsList) {
        localRequests[request] = true;
      }
    }

    emit(state.copyWith(
      selectedRequests: localRequests,
      isButtonEnabled: selectAll,
    ));
  }

  void isCheckBoxSelected(
    Emitter emit,
    RequestEntity request,
    bool isSelected,
  ) {
    final localRequest = Map<RequestEntity, bool>.from(state.selectedRequests);
    localRequest[request] = isSelected;

    if (!isSelected) {
      localRequest.remove(request);
    }
    final bool isButtonEnabled = localRequest.isNotEmpty;

    emit(state.copyWith(
      selectedRequests: localRequest,
      isSelected: isSelected,
      isButtonEnabled: isButtonEnabled,
    ));
  }
}
