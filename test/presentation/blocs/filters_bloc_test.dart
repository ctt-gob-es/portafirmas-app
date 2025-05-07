import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';

import '../../instruments/widgets_instruments.dart';

void main() {
  late FiltersBloc filtersBloc;

  setUp(() {
    filtersBloc = FiltersBloc();
  });

  group('filters bloc test', () {
    blocTest(
      'GIVEN filters bloc, WHEN filters are initialized with requestTypeFilter set to sign, THEN the state will have requestTypeFilter.sign',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(FiltersEvent.initFilters(
          initFilters: RequestFilter.initial()
              .copyWith(requestType: RequestTypeFilter.sign),
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters: RequestFilter.initial(),
          screenStatus: const ScreenStatus.loading(),
        ),
        FiltersState(
          temporalFilters: RequestFilter.initial()
              .copyWith(requestType: RequestTypeFilter.sign),
          screenStatus: const ScreenStatus.success(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN user selects mostRecent request in order filter, THEN the filters will change to OrderFilter.mostRecent',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(const FiltersEvent.selectedOrderFilter(
          orderFilter: OrderFilter.mostRecent,
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters:
              RequestFilter.initial().copyWith(order: OrderFilter.mostRecent),
          screenStatus: const ScreenStatus.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN user selects approval requests in request type filter, THEN the filters will change to RequestTypeFilter.approval',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(const FiltersEvent.selectedRequestTypeFilter(
          requestTypeFilter: RequestTypeFilter.approval,
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters: RequestFilter.initial().copyWith(
            requestType: RequestTypeFilter.approval,
          ),
          screenStatus: const ScreenStatus.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN user selects last week requests in time interval filter, THEN the filters will change to TimeIntervalFilter.lastWeek',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(const FiltersEvent.selectedTimeIntervalFilter(
          timeIntervalFilter: TimeIntervalFilter.lastWeek,
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters: RequestFilter.initial().copyWith(
            timeInterval: TimeIntervalFilter.lastWeek,
          ),
          screenStatus: const ScreenStatus.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN user selects example app in app filter, THEN the filters will change to TimeIntervalFilter.lastWeek',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(FiltersEvent.selectedAppFilter(
          app: WidgetsInstruments.getRequestAppData(),
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters: RequestFilter.initial().copyWith(
            app: WidgetsInstruments.getRequestAppData(),
          ),
          screenStatus: const ScreenStatus.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN user enters a text in the input filter, THEN the state of the inputFilter will change to that text',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(const FiltersEvent.updatedInputFilter(
          inputFilter: WidgetsInstruments.inputText,
        ));
      },
      expect: () => [
        FiltersState(
          temporalFilters: RequestFilter.initial().copyWith(
            inputFilter: WidgetsInstruments.inputText,
          ),
          screenStatus: const ScreenStatus.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN filters bloc, WHEN reset state is called, THEN the state will change to initial',
      build: () => filtersBloc,
      act: (FiltersBloc bloc) {
        bloc.add(const FiltersEvent.resetFilters(hasValidators: false));
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [
        FiltersState.initial()
            .copyWith(screenStatus: const ScreenStatus.loading()),
        FiltersState.initial()
            .copyWith(screenStatus: const ScreenStatus.success()),
      ],
    );
  });
}
