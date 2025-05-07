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
import 'package:portafirmas_app/presentation/features/filters/apps_filter/widgets/app_selection_menu_list.dart';

import '../../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../../instruments/localization_injector.dart';
import '../../../../instruments/widgets_instruments.dart';
import 'app_selection_menu_list_test.mocks.dart';

@GenerateMocks([AppFilterBloc])
void main() async {
  late MockAppFilterBloc appFilterBloc;
  late BuildContext myContext;
  late MockFlutterSecureStorage secureStorage;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('path');
    secureStorage = MockFlutterSecureStorage();
    await initDi(secureStorage: secureStorage);

    appFilterBloc = MockAppFilterBloc();
  });

  testWidgets(
    'GIVEN a App selection menu list WHEN AppFilterState is success THEN I will get a list of apps and select one',
    (widgetTester) async {
      when(appFilterBloc.stream).thenAnswer((_) => const Stream.empty());
      when(appFilterBloc.state).thenAnswer((_) => AppFilterState(
            appList: WidgetsInstruments.getRequestAppDataList(),
            screenStatus: const ScreenStatus.success(),
          ));

      await widgetTester.pumpWidget(
        LocalizationsInj(
          child: Builder(builder: (context) {
            myContext = context;

            return MaterialButton(
              onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((context) => BlocProvider<AppFilterBloc>.value(
                      value: appFilterBloc,
                      child: AppSelectionMenuList(
                        initialApp: null,
                        onChanged: (p0) => DoNothingAction(),
                      ),
                    )),
              ),
            );
          }),
        ),
      );
      //open app selection menu list modal
      final startButton = find.byType(MaterialButton);
      await widgetTester.ensureVisible(startButton);
      await widgetTester.tap(startButton, warnIfMissed: false);
      await widgetTester.pumpAndSettle();

      //Select app
      final appOption = find.text(WidgetsInstruments.getRequestAppData().name);
      await widgetTester.ensureVisible(appOption);
      await widgetTester.tap(appOption, warnIfMissed: false);
      await widgetTester.pumpAndSettle();

      //Press select button
      final selectButton = find.text(myContext.localizations.general_select);
      await widgetTester.ensureVisible(selectButton);
      await widgetTester.tap(selectButton, warnIfMissed: false);
      await widgetTester.pumpAndSettle();

      expect(
        startButton,
        findsOneWidget,
      );
    },
  );
}
