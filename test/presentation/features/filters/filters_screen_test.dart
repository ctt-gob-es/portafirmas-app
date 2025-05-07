import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/di/di.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/filters_screen.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';

import '../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'filters_screen_test.mocks.dart';

@GenerateMocks([FiltersBloc, RequestsBloc, AppFilterBloc])
void main() async {
  late MockFiltersBloc filtersBloc;
  late MockRequestsBloc mockRequestBloc;
  late AppFilterBloc appFilterBloc;
  late BuildContext myContext;
  late MockFlutterSecureStorage secureStorage;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('path');
    secureStorage = MockFlutterSecureStorage();
    await initDi(secureStorage: secureStorage);

    filtersBloc = MockFiltersBloc();
    mockRequestBloc = MockRequestsBloc();
    appFilterBloc = MockAppFilterBloc();
  });

  group('filters screen test', () {
    testWidgets(
      'GIVEN a FiltersScreen WHEN FiltersState is initial THEN I will get more recent requests in Order filter',
      (widgetTester) async {
        when(filtersBloc.stream).thenAnswer((_) => const Stream.empty());
        when(filtersBloc.state).thenAnswer((_) => FiltersState(
              temporalFilters: RequestFilter.initial(),
              screenStatus: const ScreenStatus.success(),
            ));
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockRequestBloc.state).thenAnswer((_) => RequestsState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<FiltersBloc>.value(
                  value: filtersBloc
                    ..add(
                      FiltersEvent.initFilters(
                        initFilters: RequestFilter.initial(),
                      ),
                    ),
                ),
                BlocProvider<RequestsBloc>.value(
                  value: mockRequestBloc,
                ),
              ],
              child: Builder(builder: (context) {
                myContext = context;

                return FiltersScreen(
                  initData: WidgetsInstruments.givenFilterInitData(),
                );
              }),
            ),
          ),
        );

        //1: Open order filter
        final orderFilter =
            find.text(myContext.localizations.filters_select_sort).first;
        await widgetTester.ensureVisible(orderFilter);
        await widgetTester.tap(orderFilter, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        //2: Select oldest requests and press select
        final oldestRequestFilter =
            find.text(myContext.localizations.filters_oldest_req);
        await widgetTester.ensureVisible(oldestRequestFilter);
        await widgetTester.tap(oldestRequestFilter);
        await widgetTester.pumpAndSettle();
        final selectButton = find.text(myContext.localizations.general_select);
        await widgetTester.tap(selectButton);
        await widgetTester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.filters_oldest_req),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN a FiltersScreen WHEN I tap on Request type filter THEN I will see a modal with options',
      (widgetTester) async {
        when(filtersBloc.stream).thenAnswer((_) => const Stream.empty());
        when(appFilterBloc.stream).thenAnswer((_) => const Stream.empty());
        when(filtersBloc.state).thenAnswer((_) => FiltersState(
              temporalFilters: RequestFilter.initial()
                  .copyWith(requestType: RequestTypeFilter.validated),
              screenStatus: const ScreenStatus.success(),
            ));
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockRequestBloc.state).thenAnswer((_) => RequestsState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<FiltersBloc>.value(
                  value: filtersBloc
                    ..add(
                      FiltersEvent.initFilters(
                        initFilters: RequestFilter.initial()
                            .copyWith(requestType: RequestTypeFilter.validated),
                      ),
                    ),
                ),
                BlocProvider<RequestsBloc>.value(
                  value: mockRequestBloc,
                ),
                BlocProvider<AppFilterBloc>.value(
                  value: appFilterBloc,
                ),
              ],
              child: Builder(builder: (context) {
                myContext = context;

                return FiltersScreen(
                  initData: WidgetsInstruments.givenFilterInitData(),
                );
              }),
            ),
          ),
        );

        //1: Open request type filter
        final requestTypeFilter = find
            .text(myContext.localizations.filters_select_request_type)
            .first;
        await widgetTester.ensureVisible(requestTypeFilter);
        await widgetTester.tap(requestTypeFilter, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        //2: Select sign requests and press select
        final signRequestFilter =
            find.text(myContext.localizations.filters_sign_req);
        await widgetTester.ensureVisible(signRequestFilter);
        await widgetTester.tap(signRequestFilter);
        await widgetTester.pumpAndSettle();
        final selectButton = find.text(myContext.localizations.general_select);
        await widgetTester.tap(selectButton);
        await widgetTester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.filters_sign_req),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN a FiltersScreen WHEN I tap on time interval type filter THEN I will see a modal with options',
      (widgetTester) async {
        when(filtersBloc.stream).thenAnswer((_) => const Stream.empty());
        when(appFilterBloc.stream).thenAnswer((_) => const Stream.empty());
        when(filtersBloc.state).thenAnswer((_) => FiltersState(
              temporalFilters: RequestFilter.initial(),
              screenStatus: const ScreenStatus.success(),
            ));
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockRequestBloc.state).thenAnswer((_) => RequestsState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<FiltersBloc>.value(
                  value: filtersBloc
                    ..add(
                      FiltersEvent.initFilters(
                        initFilters: RequestFilter.initial()
                            .copyWith(requestType: RequestTypeFilter.validated),
                      ),
                    ),
                ),
                BlocProvider<RequestsBloc>.value(
                  value: mockRequestBloc,
                ),
                BlocProvider<AppFilterBloc>.value(
                  value: appFilterBloc,
                ),
              ],
              child: Builder(builder: (context) {
                myContext = context;

                return FiltersScreen(
                  initData: WidgetsInstruments.givenFilterInitData(),
                );
              }),
            ),
          ),
        );

        //1: Open request type filter
        final timeIntervalFilter = find
            .text(myContext.localizations.filters_select_time_interval)
            .first;
        await widgetTester.ensureVisible(timeIntervalFilter);
        await widgetTester.tap(timeIntervalFilter, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        //2: Select last week requests and press select
        final lastWeekFilter =
            find.text(myContext.localizations.filters_last_week);
        await widgetTester.ensureVisible(lastWeekFilter);
        await widgetTester.tap(lastWeekFilter);
        await widgetTester.pumpAndSettle();
        final selectButton = find.text(myContext.localizations.general_select);
        await widgetTester.tap(selectButton);
        await widgetTester.pumpAndSettle();

        expect(
          timeIntervalFilter,
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN a FiltersScreen with filters applied WHEN I tap clear filters button THEN filters will reset',
      (widgetTester) async {
        when(filtersBloc.stream).thenAnswer((_) => const Stream.empty());
        when(appFilterBloc.stream).thenAnswer((_) => const Stream.empty());
        when(filtersBloc.state).thenAnswer((_) => FiltersState(
              temporalFilters: RequestFilter.initial()
                  .copyWith(requestType: RequestTypeFilter.validated),
              screenStatus: const ScreenStatus.success(),
            ));
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockRequestBloc.state).thenAnswer((_) => RequestsState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<FiltersBloc>.value(
                  value: filtersBloc
                    ..add(
                      FiltersEvent.initFilters(
                        initFilters: RequestFilter.initial()
                            .copyWith(requestType: RequestTypeFilter.validated),
                      ),
                    ),
                ),
                BlocProvider<AppFilterBloc>.value(
                  value: appFilterBloc,
                ),
                BlocProvider<RequestsBloc>.value(
                  value: mockRequestBloc,
                ),
              ],
              child: Builder(builder: (context) {
                myContext = context;

                return FiltersScreen(
                  initData: WidgetsInstruments.givenFilterInitData(),
                );
              }),
            ),
          ),
        );

        //1: Open time interval filter
        final timeIntervalFilter = find
            .text(myContext.localizations.filters_select_time_interval)
            .first;
        await widgetTester.ensureVisible(timeIntervalFilter);
        await widgetTester.tap(timeIntervalFilter, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        await widgetTester
            .tap(find.text(myContext.localizations.filters_last_24h));
        await widgetTester.pumpAndSettle();
        final selectButton = find.text(myContext.localizations.general_select);
        await widgetTester.tap(selectButton);
        await widgetTester.pumpAndSettle();

        //2: Press clear filter button
        final clearFiltersButton =
            find.text(myContext.localizations.filters_clear_filters_button);
        await widgetTester.ensureVisible(clearFiltersButton);
        await widgetTester.tap(clearFiltersButton);
        await widgetTester.pumpAndSettle();

        final moreRecentReqFilter = find
            .text(myContext.localizations.filters_select_time_interval)
            .first;
        // await widgetTester.tap(selectButton);
        await widgetTester.pumpAndSettle();

        expect(
          moreRecentReqFilter,
          findsOneWidget,
        );
      },
    );
  });
}
