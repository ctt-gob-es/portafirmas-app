import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/di/di.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/filters_screen_provider.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';

import '../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'filters_screen_test.mocks.dart';

@GenerateMocks([FiltersBloc, RequestsBloc, FlutterSecureStorage])
void main() async {
  late MockFiltersBloc filtersBloc;
  late MockRequestsBloc signerRequestsBloc;
  late BuildContext myContext;
  late MockFlutterSecureStorage secureStorage;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('path');
    secureStorage = MockFlutterSecureStorage();
    await initDi(secureStorage: secureStorage);
    filtersBloc = MockFiltersBloc();
    signerRequestsBloc = MockRequestsBloc();
  });

  group('filters screen provider test', () {
    testWidgets(
      'GIVEN a FiltersScreenProvider WHEN FiltersState is initial THEN I will get Filters title',
      (widgetTester) async {
        when(filtersBloc.stream).thenAnswer((_) => const Stream.empty());
        when(filtersBloc.state).thenAnswer((_) => FiltersState(
              temporalFilters: RequestFilter.initial(),
              screenStatus: const ScreenStatus.success(),
            ));
        when(signerRequestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signerRequestsBloc.state)
            .thenAnswer((_) => RequestsState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: BlocProvider<FiltersBloc>.value(
              value: filtersBloc,
              child: Builder(builder: (context) {
                myContext = context;

                return BlocProvider<RequestsBloc>.value(
                  value: signerRequestsBloc,
                  child: FiltersScreenProvider(
                    filterInitData: WidgetsInstruments.givenFilterInitData(),
                  ),
                );
              }),
            ),
          ),
        );

        final filtersTitle = find.text(myContext.localizations.filters_title);

        expect(
          filtersTitle,
          findsOneWidget,
        );
      },
    );
  });
}
