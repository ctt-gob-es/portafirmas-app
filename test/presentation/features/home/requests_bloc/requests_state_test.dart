import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';

void main() {
  group('getUpdatedFilters', () {
    test('should update signedFilter when status is signed', () {
      final initialFilters = RequestFilters(
        pendingFilter: RequestFilter.initial(),
        signedFilter: RequestFilter.initial(),
        rejectedFilter: RequestFilter.initial(),
        validatedFilter: RequestFilter.validated(),
      );

      const filterToUpdate = RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.all,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: 'abc',
        app: RequestAppData(id: '123', name: 'abc'),
      );

      final state = RequestsState.initial().copyWith(filters: initialFilters);

      final updatedFilters =
          state.getUpdatedFilters(RequestStatus.signed, filterToUpdate);

      expect(updatedFilters.signedFilter, filterToUpdate);
    });

    test('should update signedFilter when status is validated', () {
      final initialFilters = RequestFilters(
        pendingFilter: RequestFilter.initial(),
        signedFilter: RequestFilter.initial(),
        rejectedFilter: RequestFilter.initial(),
        validatedFilter: RequestFilter.validated(),
      );

      const filterToUpdate = RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.all,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: 'abc',
        app: RequestAppData(id: '123', name: 'abc'),
      );

      final state = RequestsState.initial().copyWith(filters: initialFilters);

      final updatedFilters =
          state.getUpdatedFilters(RequestStatus.validated, filterToUpdate);

      expect(updatedFilters.validatedFilter, filterToUpdate);
    });

    test('should update signedFilter when status is rejected', () {
      final initialFilters = RequestFilters(
        pendingFilter: RequestFilter.initial(),
        signedFilter: RequestFilter.initial(),
        rejectedFilter: RequestFilter.initial(),
        validatedFilter: RequestFilter.validated(),
      );

      const filterToUpdate = RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.all,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: 'abc',
        app: RequestAppData(id: '123', name: 'abc'),
      );

      final state = RequestsState.initial().copyWith(filters: initialFilters);

      final updatedFilters =
          state.getUpdatedFilters(RequestStatus.rejected, filterToUpdate);

      expect(updatedFilters.rejectedFilter, filterToUpdate);
    });

    test(
      'should update pendingFilter when status is not signed, rejected, or validated',
      () {
        final initialFilters = RequestFilters(
          pendingFilter: const RequestFilter(
            order: OrderFilter.oldest,
            requestType: RequestTypeFilter.all,
            timeInterval: TimeIntervalFilter.all,
            inputFilter: 'abc',
            app: RequestAppData(id: '123', name: 'abc'),
          ),
          signedFilter: const RequestFilter(
            order: OrderFilter.oldest,
            requestType: RequestTypeFilter.all,
            timeInterval: TimeIntervalFilter.all,
            inputFilter: 'abc',
            app: RequestAppData(id: '123', name: 'abc'),
          ),
          rejectedFilter: const RequestFilter(
            order: OrderFilter.oldest,
            requestType: RequestTypeFilter.all,
            timeInterval: TimeIntervalFilter.all,
            inputFilter: 'abc',
            app: RequestAppData(id: '123', name: 'abc'),
          ),
          validatedFilter: const RequestFilter(
            order: OrderFilter.oldest,
            requestType: RequestTypeFilter.all,
            timeInterval: TimeIntervalFilter.all,
            inputFilter: 'abc',
            app: RequestAppData(id: '123', name: 'abc'),
          ),
        );

        const filterToUpdate = RequestFilter(
          order: OrderFilter.mostRecent,
          requestType: RequestTypeFilter.all,
          timeInterval: TimeIntervalFilter.all,
          inputFilter: 'abc',
          app: RequestAppData(id: '123', name: 'abc'),
        );

        final state = RequestsState.initial().copyWith(filters: initialFilters);

        final updatedFilters =
            state.getUpdatedFilters(RequestStatus.pending, filterToUpdate);

        expect(
          updatedFilters.pendingFilter.order,
          equals(OrderFilter.mostRecent),
        );
      },
    );

    group('RequestsState', () {
      late RequestsState requestsState;

      test(
        'requestCountIsNotEmpty should return true if validatedRequestsStatus is not null',
        () {
          requestsState = RequestsState(
            hasValidators: null,
            isSigner: null,
            filters: RequestFilters(
              pendingFilter: RequestFilter.initial(),
              signedFilter: RequestFilter.initial(),
              rejectedFilter: RequestFilter.initial(),
              validatedFilter: RequestFilter.validated(),
            ),
            pendingRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            signedRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            rejectedRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            validatedRequestsStatus: const RequestsStatus(
              requestsCount: 7,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            filtersActive: false,
          );

          expect(requestsState.requestCountIsNotEmpty, true);
        },
      );

      test(
        'requestCountIsNotEmpty should return true if signedRequestsStatus is not null',
        () {
          requestsState = RequestsState(
            hasValidators: null,
            isSigner: null,
            filters: RequestFilters(
              pendingFilter: RequestFilter.initial(),
              signedFilter: RequestFilter.initial(),
              rejectedFilter: RequestFilter.initial(),
              validatedFilter: RequestFilter.validated(),
            ),
            pendingRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            signedRequestsStatus: const RequestsStatus(
              requestsCount: 3,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            rejectedRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            validatedRequestsStatus: const RequestsStatus(
              requestsCount: null,
              requests: [],
              screenStatus: ScreenStatus.initial(),
            ),
            filtersActive: false,
          );

          expect(requestsState.requestCountIsNotEmpty, true);
        },
      );
    });

    group('getInitFilter', () {
      late RequestFilters filters;

      setUp(() {
        filters = RequestFilters(
          pendingFilter: RequestFilter.initial(),
          signedFilter: RequestFilter.initial(),
          rejectedFilter: RequestFilter.initial(),
          validatedFilter: RequestFilter.validated(),
        );
      });

      test(
        'should return signedFilter when isSigner is true and tabIndex is 1',
        () {
          final state = RequestsState(
            hasValidators: null,
            isSigner: true,
            filters: filters,
            pendingRequestsStatus: RequestsStatus.initial(),
            signedRequestsStatus: RequestsStatus.initial(),
            rejectedRequestsStatus: RequestsStatus.initial(),
            validatedRequestsStatus: RequestsStatus.initial(),
            filtersActive: false,
          );

          final result = state.getInitFilter(1);

          expect(result, filters.signedFilter);
        },
      );

      test(
        'should return rejectedFilter when isSigner is true and tabIndex is 2',
        () {
          final state = RequestsState(
            hasValidators: null,
            isSigner: true,
            filters: filters,
            pendingRequestsStatus: RequestsStatus.initial(),
            signedRequestsStatus: RequestsStatus.initial(),
            rejectedRequestsStatus: RequestsStatus.initial(),
            validatedRequestsStatus: RequestsStatus.initial(),
            filtersActive: false,
          );

          final result = state.getInitFilter(2);

          expect(result, filters.rejectedFilter);
        },
      );

      test(
        'should return pendingFilter when isSigner is true and tabIndex is default',
        () {
          final state = RequestsState(
            hasValidators: null,
            isSigner: true,
            filters: filters,
            pendingRequestsStatus: RequestsStatus.initial(),
            signedRequestsStatus: RequestsStatus.initial(),
            rejectedRequestsStatus: RequestsStatus.initial(),
            validatedRequestsStatus: RequestsStatus.initial(),
            filtersActive: false,
          );

          final result = state.getInitFilter(0);

          expect(result, filters.pendingFilter);
        },
      );

      test(
        'should return validatedFilter when isSigner is false and tabIndex is 1',
        () {
          final state = RequestsState(
            hasValidators: null,
            isSigner: false,
            filters: filters,
            pendingRequestsStatus: RequestsStatus.initial(),
            signedRequestsStatus: RequestsStatus.initial(),
            rejectedRequestsStatus: RequestsStatus.initial(),
            validatedRequestsStatus: RequestsStatus.initial(),
            filtersActive: false,
          );

          final result = state.getInitFilter(1);

          expect(result, filters.validatedFilter);
        },
      );

      test(
        'should return pendingFilter when isSigner is false and tabIndex is default',
        () {
          final state = RequestsState(
            hasValidators: null,
            isSigner: false,
            filters: filters,
            pendingRequestsStatus: RequestsStatus.initial(),
            signedRequestsStatus: RequestsStatus.initial(),
            rejectedRequestsStatus: RequestsStatus.initial(),
            validatedRequestsStatus: RequestsStatus.initial(),
            filtersActive: false,
          );

          final result = state.getInitFilter(0);

          expect(result, filters.pendingFilter);
        },
      );
    });
  });
}
