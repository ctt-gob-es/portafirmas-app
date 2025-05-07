/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';

part 'detail_request_bloc.freezed.dart';
part 'detail_request_event.dart';
part 'detail_request_state.dart';

class DetailRequestBloc extends Bloc<DetailRequestEvent, DetailRequestState> {
  final RequestRepositoryContract _repository;

  DetailRequestBloc({required RequestRepositoryContract repositoryContract})
      : _repository = repositoryContract,
        super(DetailRequestState.initial()) {
    on<DetailRequestEvent>(
      (event, emit) async {
        await event.when(
          fetchDataRequest: (requestId) => _fetchData(emit, requestId),
          footerVisibility: () {
            emit(state.copyWith(isFooterActive: false));
          },
        );
      },
    );
  }

  FutureOr<void> _fetchData(
    Emitter<DetailRequestState> emit,
    String requestId,
  ) async {
    emit(
      state.copyWith(
        screenStatus: const ScreenStatus.loading(),
        isFooterActive: true,
      ),
    );
    final result = await _repository.getRequestDetail(requestId);

    result.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
        ),
      ),
      success: (data) {
        emit(
          state.copyWith(
            screenStatus: const ScreenStatus.success(),
            loadContent: data,
          ),
        );
      },
    );
  }
}
