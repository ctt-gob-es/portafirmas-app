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
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/request_status.dart';

part 'requests_bloc.freezed.dart';
part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  static const int _itemsInPage = 50;
  final RequestRepositoryContract _requestRepositoryContract;
  final ValidatorListRepositoryContract _validatorListRepositoryContract;

  RequestsBloc({
    required RequestRepositoryContract requestsRepositoryContract,
    required ValidatorListRepositoryContract validatorListRepositoryContract,
  })  : _requestRepositoryContract = requestsRepositoryContract,
        _validatorListRepositoryContract = validatorListRepositoryContract,
        super(RequestsState.initial()) {
    on<RequestsEvent>((event, emit) async {
      await event.when(
        loadMorePendingRequests: (bool isSigner) =>
            _mapToLoadMorePendingRequests(event, emit, isSigner),
        loadMoreSignedRequests: () => _mapToLoadMoreSignedRequests(event, emit),
        loadMoreRejectedRequests: (bool isSigner) =>
            _mapToLoadMoreRejectedRequests(event, emit, isSigner),
        loadMoreValidatedRequests: () =>
            _mapToLoadMoreValidatedRequests(event, emit),
        cleanFilters: () async =>
            emit(state.copyWith(filters: RequestFilters.initial())),
        updateFilter: (
          RequestFilters newFilters,
          bool? isSigner,
          String? dniValidatorFilter,
          bool? validatorsChecked,
        ) {
          if (newFilters != state.filters) {
            emit(RequestsState.initial().copyWith(
              isSigner: isSigner ?? state.isSigner,
              hasValidators: state.hasValidators,
              filters: newFilters,
            ));
          }
          emit(state.copyWith(
            dniValidatorFilter: dniValidatorFilter,
            validatorsChecked: validatorsChecked ?? state.validatorsChecked,
          ));
        },
        checkFilters: (RequestStatus requestStatus) {
          emit(state.copyWith(
            filtersActive: state.hasFilterActive(requestStatus),
          ));
        },
        resetState: () {
          emit(RequestsState.initial().copyWith(
            isSigner: state.isSigner,
            hasValidators: state.hasValidators,
            filters: state.filters,
            dniValidatorFilter: state.dniValidatorFilter,
            validatorsChecked: state.validatorsChecked,
          ));
        },
        reloadRequests: (RequestStatus? requestStatus) {
          emit(state.copyWith(
            pendingRequestsStatus: requestStatus?.isPending() ??
                    state.currentRequestsStatus?.isPending() ??
                    false
                ? RequestsStatus.initial()
                : state.pendingRequestsStatus,
            signedRequestsStatus: requestStatus?.isSigned() ??
                    state.currentRequestsStatus?.isSigned() ??
                    false
                ? RequestsStatus.initial()
                : state.signedRequestsStatus,
            rejectedRequestsStatus: requestStatus?.isRejected() ??
                    state.currentRequestsStatus?.isRejected() ??
                    false
                ? RequestsStatus.initial()
                : state.rejectedRequestsStatus,
            validatedRequestsStatus: requestStatus?.isValidated() ??
                    state.currentRequestsStatus?.isValidated() ??
                    false
                ? RequestsStatus.initial()
                : state.validatedRequestsStatus,
            currentRequestsStatus: requestStatus ?? state.currentRequestsStatus,
          ));
        },
      );
    });
  }

  Future<void> _mapToLoadMoreRequests({
    required RequestsStatus actualStatus,
    required Function(RequestsStatus newStatus) onChange,
    required GetRequest getRequests,
    required RequestFilter filter,
  }) async {
    int actualCount = actualStatus.requests.length;
    int lastLoadedPage = (actualCount / _itemsInPage).round();
    ScreenStatus actualScreenStatus = actualStatus.screenStatus;
    int? allCount = actualStatus.requestsCount;

    if (actualScreenStatus.isLoading() || allCount == 0) return;

    if (allCount == null || actualCount < (allCount)) {
      actualStatus = actualStatus.copyWith(
        screenStatus: const ScreenStatus.loading(),
      );
      onChange(actualStatus);

      final result = await getRequests(
        page: lastLoadedPage + 1,
        pageSize: _itemsInPage,
        filter: filter,
        dniValidator: state.dniValidatorFilter,
      );
      result.when(
        failure: (e) => onChange(actualStatus.copyWith(
          screenStatus: ScreenStatus.error(e),
        )),
        success: (list) => onChange(
          actualStatus.copyWith(
            requestsCount: list.count,
            screenStatus: const ScreenStatus.success(),
            requests: [
              ...actualStatus.requests,
              ...list.requests,
            ],
          ),
        ),
      );
    }
  }

  _mapToLoadMorePendingRequests(
    RequestsEvent event,
    Emitter<RequestsState> emit,
    bool isSigner,
  ) async {
    //If first time, check validators
    if ((state.validatorsChecked == null || state.validatorsChecked == false) &&
        isSigner) {
      await _checkValidators(emit);
    }
    await _mapToLoadMoreRequests(
      actualStatus: state.pendingRequestsStatus,
      filter: state.filters.pendingFilter,
      onChange: (newStatus) => emit(
        state.copyWith(pendingRequestsStatus: newStatus, isSigner: isSigner),
      ),
      getRequests: _requestRepositoryContract.getPendingRequests,
    );
  }

  _mapToLoadMoreSignedRequests(
    RequestsEvent event,
    Emitter<RequestsState> emit,
  ) async {
    await _mapToLoadMoreRequests(
      actualStatus: state.signedRequestsStatus,
      filter: state.filters.signedFilter ?? RequestFilter.initial(),
      onChange: (newStatus) =>
          emit(state.copyWith(signedRequestsStatus: newStatus)),
      getRequests: _requestRepositoryContract.getSignedRequests,
    );
  }

  _mapToLoadMoreRejectedRequests(
    RequestsEvent event,
    Emitter<RequestsState> emit,
    bool isSigner,
  ) async {
    await _mapToLoadMoreRequests(
      actualStatus: state.rejectedRequestsStatus,
      filter: state.filters.rejectedFilter ?? RequestFilter.initial(),
      onChange: (newStatus) =>
          emit(state.copyWith(rejectedRequestsStatus: newStatus)),
      getRequests: _requestRepositoryContract.getRejectedRequests,
    );
  }

  _mapToLoadMoreValidatedRequests(
    RequestsEvent event,
    Emitter<RequestsState> emit,
  ) async {
    await _mapToLoadMoreRequests(
      actualStatus: state.validatedRequestsStatus,
      filter: state.filters.validatedFilter ?? RequestFilter.validated(),
      onChange: (newStatus) =>
          emit(state.copyWith(validatedRequestsStatus: newStatus)),
      getRequests: _requestRepositoryContract.getPendingRequests,
    );
  }

  FutureOr<void> _checkValidators(Emitter emit) async {
    // checks if user has validators
    final result =
        await _validatorListRepositoryContract.getValidatorUserList();
    result.when(
      failure: (error) => emit(state.copyWith(
        pendingRequestsStatus: RequestsStatus.initial().copyWith(
          screenStatus: const ScreenStatus.error(),
        ),
      )),
      success: (validators) => emit(state.copyWith(
        hasValidators: validators.isNotEmpty,
        filters: state.filters.copyWith(
          pendingFilter: validators.isNotEmpty
              ? RequestFilter.validated()
              : RequestFilter.initial(),
        ),
        validatorsChecked: true,
      )),
    );
  }
}
