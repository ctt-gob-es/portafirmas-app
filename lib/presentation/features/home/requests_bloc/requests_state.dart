
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'requests_bloc.dart';

@freezed
class RequestsState with _$RequestsState {
  const factory RequestsState({
    /// General
    required bool? hasValidators,
    required bool? isSigner,
    required RequestFilters filters,

    ///
    /// Pending requests
    required RequestsStatus pendingRequestsStatus,

    ///
    /// Signed requests
    required RequestsStatus signedRequestsStatus,

    ///
    /// Rejected requests
    required RequestsStatus rejectedRequestsStatus,

    ///
    /// Validated requests
    required RequestsStatus validatedRequestsStatus,

    ///
    /// true if filters are active
    required bool filtersActive,

    //Current tab Request status
    RequestStatus? currentRequestsStatus,

    //true if the app has check if user has validators
    bool? validatorsChecked,
    //DNI of the user of which you are validator
    String? dniValidatorFilter,
  }) = _RequestsState;

  factory RequestsState.initial() {
    return RequestsState(
      hasValidators: null,
      isSigner: null,
      filters: RequestFilters(
        pendingFilter: RequestFilter.initial(),
        signedFilter: RequestFilter.initial(),
        rejectedFilter: RequestFilter.initial(),
        validatedFilter: RequestFilter.validated(),
      ),
      pendingRequestsStatus: RequestsStatus.initial(),
      signedRequestsStatus: RequestsStatus.initial(),
      rejectedRequestsStatus: RequestsStatus.initial(),
      validatedRequestsStatus: RequestsStatus.initial(),
      filtersActive: false,
    );
  }
}

extension SignerRequestsStateExtension on RequestsState {
  bool get isSignerAndHasValidators =>
      ((hasValidators ?? false) && (isSigner ?? false));
  bool get isValidator => !(isSigner ?? false);

  List<RequestEntity> get expiresTodayRequests => pendingRequestsStatus.requests
      .where((element) => element.expiresToday)
      .toList();

  List<RequestEntity> get allRequestsExceptExpiresToday =>
      pendingRequestsStatus.requests
          .where((element) => !element.expiresToday)
          .toList();

  bool get requestCountIsNotEmpty {
    return pendingRequestsStatus.requestsCount != null ||
        rejectedRequestsStatus.requestsCount != null ||
        validatedRequestsStatus.requestsCount != null ||
        signedRequestsStatus.requestsCount != null;
  }

  bool hasFilterActive(RequestStatus requestStatus) {
    switch (requestStatus) {
      case RequestStatus.pending:
        return isSignerAndHasValidators
            ? filters.pendingFilter != RequestFilter.validated()
            : isValidator
                ? filters.pendingFilter != RequestFilter.notValidated()
                : filters.pendingFilter != RequestFilter.initial();
      case RequestStatus.signed:
        return filters.signedFilter != RequestFilter.initial();
      case RequestStatus.rejected:
        return filters.rejectedFilter != RequestFilter.initial();
      case RequestStatus.validated:
        return filters.validatedFilter != RequestFilter.validated();
    }
  }

  bool isOnlyOrderFilter(RequestStatus requestStatus) {
    final initialValidatorsOldest =
        RequestFilter.validated().copyWith(order: OrderFilter.oldest);
    final initialValidatorsExpire =
        RequestFilter.validated().copyWith(order: OrderFilter.aboutToExpire);
    final initialOldest =
        RequestFilter.initial().copyWith(order: OrderFilter.oldest);
    final initialExpire =
        RequestFilter.initial().copyWith(order: OrderFilter.aboutToExpire);

    switch (requestStatus) {
      case RequestStatus.pending:
        return isSignerAndHasValidators
            ? (filters.pendingFilter == initialValidatorsOldest) ||
                (filters.pendingFilter == initialValidatorsExpire)
            : (filters.pendingFilter == initialOldest) ||
                (filters.pendingFilter == initialExpire);
      case RequestStatus.signed:
        return (filters.signedFilter == initialOldest) ||
            (filters.signedFilter == initialExpire);
      case RequestStatus.rejected:
        return (filters.rejectedFilter == initialOldest) ||
            (filters.rejectedFilter == initialExpire);
      case RequestStatus.validated:
        return (filters.validatedFilter == initialValidatorsOldest) ||
            (filters.validatedFilter == initialValidatorsExpire);
    }
  }

  RequestFilter getInitFilter(
    int tabIndex,
  ) {
    if (isSigner ?? false) {
      switch (tabIndex) {
        case 1:
          return filters.signedFilter ?? RequestFilter.initial();
        case 2:
          return filters.rejectedFilter ?? RequestFilter.initial();
        default:
          return filters.pendingFilter;
      }
    } else {
      switch (tabIndex) {
        case 1:
          return filters.validatedFilter ?? RequestFilter.initial();
        default:
          return filters.pendingFilter;
      }
    }
  }

  RequestStatus getTabRequestStatus(int tabIndex) {
    if (isSigner ?? false) {
      switch (tabIndex) {
        case 1:
          return RequestStatus.signed;
        case 2:
          return RequestStatus.rejected;
        default:
          return RequestStatus.pending;
      }
    } else {
      switch (tabIndex) {
        case 1:
          return RequestStatus.validated;
        default:
          return RequestStatus.pending;
      }
    }
  }

  //obtain clean filters

  RequestFilters getCleanRequestTypeFilter(
    RequestStatus requestStatus,
  ) {
    switch (requestStatus) {
      case RequestStatus.pending:
        return filters.copyWith(
          pendingFilter: filters.pendingFilter.copyWith(
            requestType: isSignerAndHasValidators
                ? RequestTypeFilter.validated
                : isValidator
                    ? RequestTypeFilter.notValidated
                    : RequestTypeFilter.all,
          ),
        );
      case RequestStatus.signed:
        return filters.copyWith(
          signedFilter: filters.signedFilter
              ?.copyWith(requestType: RequestTypeFilter.all),
        );
      case RequestStatus.rejected:
        return filters.copyWith(
          rejectedFilter: filters.rejectedFilter
              ?.copyWith(requestType: RequestTypeFilter.all),
        );
      case RequestStatus.validated:
        return filters.copyWith(
          validatedFilter: filters.validatedFilter
              ?.copyWith(requestType: RequestTypeFilter.validated),
        );
    }
  }

  RequestFilters getCleanInputFilter(RequestStatus requestStatus) {
    return filters.copyWith(
      pendingFilter: filters.pendingFilter.copyWith(
        inputFilter: requestStatus == RequestStatus.pending
            ? null
            : filters.pendingFilter.inputFilter,
      ),
      signedFilter: filters.signedFilter?.copyWith(
        inputFilter: requestStatus == RequestStatus.signed
            ? null
            : filters.signedFilter?.inputFilter,
      ),
      rejectedFilter: filters.rejectedFilter?.copyWith(
        inputFilter: requestStatus == RequestStatus.rejected
            ? null
            : filters.rejectedFilter?.inputFilter,
      ),
      validatedFilter: filters.validatedFilter?.copyWith(
        inputFilter: requestStatus == RequestStatus.validated
            ? null
            : filters.validatedFilter?.inputFilter,
      ),
    );
  }

  RequestFilters getCleanTimeIntervalFilter(RequestStatus requestStatus) {
    return filters.copyWith(
      pendingFilter: filters.pendingFilter.copyWith(
        timeInterval: requestStatus == RequestStatus.pending
            ? TimeIntervalFilter.all
            : filters.pendingFilter.timeInterval,
      ),
      signedFilter: filters.signedFilter?.copyWith(
        timeInterval: requestStatus == RequestStatus.signed
            ? TimeIntervalFilter.all
            : filters.signedFilter?.timeInterval ?? TimeIntervalFilter.all,
      ),
      rejectedFilter: filters.rejectedFilter?.copyWith(
        timeInterval: requestStatus == RequestStatus.rejected
            ? TimeIntervalFilter.all
            : filters.rejectedFilter?.timeInterval ?? TimeIntervalFilter.all,
      ),
      validatedFilter: filters.validatedFilter?.copyWith(
        timeInterval: requestStatus == RequestStatus.validated
            ? TimeIntervalFilter.all
            : filters.validatedFilter?.timeInterval ?? TimeIntervalFilter.all,
      ),
    );
  }

  RequestFilters getCleanAppFilter(RequestStatus status) {
    return filters.copyWith(
      pendingFilter: filters.pendingFilter.copyWith(
        app: status == RequestStatus.pending ? null : filters.pendingFilter.app,
      ),
      signedFilter: filters.signedFilter?.copyWith(
        app: status == RequestStatus.signed ? null : filters.signedFilter?.app,
      ),
      rejectedFilter: filters.rejectedFilter?.copyWith(
        app: status == RequestStatus.rejected
            ? null
            : filters.rejectedFilter?.app,
      ),
      validatedFilter: filters.validatedFilter?.copyWith(
        app: status == RequestStatus.validated
            ? null
            : filters.validatedFilter?.app,
      ),
    );
  }

  RequestFilter? getCurrentFilter(
    RequestStatus status,
  ) {
    switch (status) {
      case RequestStatus.pending:
        return filters.pendingFilter;
      case RequestStatus.signed:
        return filters.signedFilter;
      case RequestStatus.rejected:
        return filters.rejectedFilter;
      case RequestStatus.validated:
        return filters.validatedFilter;
    }
  }

  RequestFilters getUpdatedFilters(
    RequestStatus status,
    RequestFilter filter,
  ) {
    switch (status) {
      case RequestStatus.signed:
        return filters.copyWith(signedFilter: filter);
      case RequestStatus.rejected:
        return filters.copyWith(rejectedFilter: filter);
      case RequestStatus.validated:
        return filters.copyWith(validatedFilter: filter);
      default:
        return filters.copyWith(
          pendingFilter: filter,
        );
    }
  }
}
