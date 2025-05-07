import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';

import '../../data/instruments/request_data_instruments.dart';
import '../instruments/requests_instruments.dart';
import 'requests_bloc_test.mocks.dart';

@GenerateMocks([
  RequestRepositoryContract,
  ValidatorListRepositoryContract,
])
void main() {
  late MockRequestRepositoryContract requestRepository;
  late MockValidatorListRepositoryContract validatorRepository;
  late RequestsBloc requestsBloc;

  setUp(() {
    requestRepository = MockRequestRepositoryContract();
    validatorRepository = MockValidatorListRepositoryContract();
    requestsBloc = RequestsBloc(
      requestsRepositoryContract: requestRepository,
      validatorListRepositoryContract: validatorRepository,
    );
  });

  group('Pending requests', () {
    blocTest(
      'GIVEN request bloc initial, WHEN load pending request is called, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));

        when(validatorRepository.getValidatorUserList()).thenAnswer(
          (realInvocation) async => Result.success(givenValidatorEntityList()),
        );
        bloc.add(const RequestsEvent.loadMorePendingRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial()
              .copyWith(screenStatus: const ScreenStatus.initial()),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.success(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc initial, WHEN load more pending request with error, then screen error',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));
        when(validatorRepository.getValidatorUserList()).thenAnswer(
          (realInvocation) async => Result.success(givenValidatorEntityList()),
        );

        bloc.add(const RequestsEvent.loadMorePendingRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial()
              .copyWith(screenStatus: const ScreenStatus.initial()),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc with items, WHEN load more pending request, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));

        when(validatorRepository.getValidatorUserList()).thenAnswer(
          (realInvocation) async => Result.success(givenValidatorEntityList()),
        );
        bloc.emit(RequestsState.initial().copyWith(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          pendingRequestsStatus: givenInitialStatusWithRequests,
          isSigner: true,
        ));
        bloc.add(const RequestsEvent.loadMorePendingRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: givenInitialStatusWithRequests,
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: null,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.success(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.loading(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
        RequestsState(
          hasValidators: true,
          filters: RequestFilters.initialWithValidators(),
          isSigner: true,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: [
              ...givenRequestEntityList(),
              ...givenRequestEntityList(),
            ],
            screenStatus: const ScreenStatus.success(),
          ),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
          validatorsChecked: true,
        ),
      ],
    );
  });
  group('Signed requests', () {
    blocTest(
      'GIVEN request bloc initial, WHEN load more signed request, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getSignedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));
        bloc.add(const RequestsEvent.loadMoreSignedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.success(),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc initial, WHEN load more signed request with error, then screen error',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getSignedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));
        bloc.add(const RequestsEvent.loadMoreSignedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          pendingRequestsStatus: RequestsStatus.initial(),
          validatedRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc with items, WHEN load more signed request, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getSignedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));

        bloc.emit(RequestsState.initial().copyWith(
          hasValidators: false,
          signedRequestsStatus: givenInitialStatusWithRequests,
        ));
        bloc.add(const RequestsEvent.loadMoreSignedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: givenInitialStatusWithRequests,
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.loading(),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: [
              ...givenRequestEntityList(),
              ...givenRequestEntityList(),
            ],
            screenStatus: const ScreenStatus.success(),
          ),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );
  });
  group('Rejected requests', () {
    blocTest(
      'GIVEN request bloc initial, WHEN load more signed request, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getRejectedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));
        bloc.add(const RequestsEvent.loadMoreRejectedRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.success(),
          ),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc initial, WHEN load more signed request with error, then screen error',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getRejectedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));
        bloc.add(const RequestsEvent.loadMoreRejectedRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          ),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc with items, WHEN load more signed request, then loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getRejectedRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: anyNamed('filter'),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));

        bloc.emit(RequestsState.initial().copyWith(
          hasValidators: false,
          rejectedRequestsStatus: givenInitialStatusWithRequests,
        ));
        bloc.add(const RequestsEvent.loadMoreRejectedRequests(isSigner: true));
      },
      expect: () => [
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: givenInitialStatusWithRequests,
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.loading(),
          ),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus.initial(),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: [
              ...givenRequestEntityList(),
              ...givenRequestEntityList(),
            ],
            screenStatus: const ScreenStatus.success(),
          ),
          filtersActive: false,
        ),
      ],
    );
  });

  group('Validated requests', () {
    blocTest(
      'GIVEN request bloc, WHEN load more validated request, THEN loads the requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: RequestFilter.validated(),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));
        bloc.add(const RequestsEvent.loadMoreValidatedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.success(),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc, WHEN load more validated request with error, then screen error',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: RequestFilter.validated(),
        )).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));
        bloc.add(const RequestsEvent.loadMoreValidatedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.loading(),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: null,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: const RequestsStatus(
            requestsCount: null,
            requests: [],
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );

    blocTest(
      'GIVEN request bloc with items, WHEN load more validated request, then shows more requests',
      build: () => requestsBloc,
      act: (RequestsBloc bloc) {
        when(requestRepository.getPendingRequests(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          filter: RequestFilter.validated(),
        )).thenAnswer((_) async => Result.success(givenRequestListEntity()));

        bloc.emit(RequestsState.initial().copyWith(
          hasValidators: false,
          validatedRequestsStatus: givenInitialStatusWithRequests,
        ));
        bloc.add(const RequestsEvent.loadMoreValidatedRequests());
      },
      expect: () => [
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: givenInitialStatusWithRequests,
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: givenRequestEntityList(),
            screenStatus: const ScreenStatus.loading(),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
        RequestsState(
          hasValidators: false,
          filters: RequestFilters.initial(),
          isSigner: null,
          validatedRequestsStatus: RequestsStatus(
            requestsCount: 20,
            requests: [
              ...givenRequestEntityList(),
              ...givenRequestEntityList(),
            ],
            screenStatus: const ScreenStatus.success(),
          ),
          pendingRequestsStatus: RequestsStatus.initial(),
          signedRequestsStatus: RequestsStatus.initial(),
          rejectedRequestsStatus: RequestsStatus.initial(),
          filtersActive: false,
        ),
      ],
    );

    blocTest<RequestsBloc, RequestsState>(
      'emits initial state when resetState is called',
      build: () {
        return requestsBloc;
      },
      act: (bloc) {
        bloc.add(const RequestsEvent.resetState());
      },
      expect: () => [
        isA<RequestsState>()
            .having((state) => state.isSigner, 'isSigner', null)
            .having((state) => state.hasValidators, 'hasValidators', null)
            .having(
              (state) => state.filters,
              'filters',
              RequestFilters.initial(),
            )
            .having(
              (state) => state.dniValidatorFilter,
              'dniValidatorFilter',
              null,
            )
            .having(
              (state) => state.validatorsChecked,
              'validatorsChecked',
              null,
            )
            .having(
              (state) => state.pendingRequestsStatus,
              'pendingRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.signedRequestsStatus,
              'signedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.rejectedRequestsStatus,
              'rejectedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.validatedRequestsStatus,
              'validatedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having((state) => state.filtersActive, 'filtersActive', false)
            .having(
              (state) => state.currentRequestsStatus,
              'currentRequestsStatus',
              null,
            ),
      ],
    );

    blocTest<RequestsBloc, RequestsState>(
      'emits updated state with reloadRequests',
      build: () {
        return requestsBloc;
      },
      act: (bloc) {
        bloc.add(const RequestsEvent.reloadRequests(
          requestStatus: RequestStatus.pending,
        ));
      },
      expect: () => [
        isA<RequestsState>()
            .having(
              (state) => state.pendingRequestsStatus,
              'pendingRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.signedRequestsStatus,
              'signedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.rejectedRequestsStatus,
              'rejectedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.validatedRequestsStatus,
              'validatedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having((state) => state.filtersActive, 'filtersActive', false)
            .having(
              (state) => state.currentRequestsStatus,
              'currentRequestsStatus',
              RequestStatus.pending,
            ),
      ],
    );

    blocTest<RequestsBloc, RequestsState>(
      'emits updated state when reloadRequests is called with requestStatus',
      build: () {
        return requestsBloc;
      },
      act: (bloc) {
        const requestStatus = RequestStatus.pending;
        bloc.add(const RequestsEvent.reloadRequests(
          requestStatus: requestStatus,
        ));
      },
      expect: () => [
        isA<RequestsState>()
            .having(
              (state) => state.pendingRequestsStatus,
              'pendingRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.signedRequestsStatus,
              'signedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.rejectedRequestsStatus,
              'rejectedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.validatedRequestsStatus,
              'validatedRequestsStatus',
              RequestsStatus.initial(),
            )
            .having(
              (state) => state.currentRequestsStatus,
              'currentRequestsStatus',
              RequestStatus.pending,
            ),
      ],
    );
  });
}
