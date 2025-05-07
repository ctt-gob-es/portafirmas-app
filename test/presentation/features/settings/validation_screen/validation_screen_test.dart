import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/validation_screen.dart';

import '../../../../data/instruments/request_data_instruments.dart';
import '../../../instruments/pump_app.dart';
import 'validation_screen_test.mocks.dart';

@GenerateMocks([ValidationScreenBloc])
void main() {
  late MockValidationScreenBloc bloc;
  setUp(() {
    bloc = MockValidationScreenBloc();
  });

  group(
    'Validator screen test',
    () {
      testWidgets(
        'GIVEN validator screen, WHEN show screen THEN load validator list',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => ValidationScreenState.initial().copyWith(
              listOfValidatorUsers: givenValidatorUser(),
              screenStatus: const ScreenStatus.success(),
            ),
          );

          await widgetTester.pumpApp(
            const ValidationScreen(),
            onGetContext: (context) => context,
            providers: [
              BlocProvider<ValidationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(ListTile), findsOneWidget);

          await widgetTester.tap(find.byType(ListTile));
          await widgetTester.pumpAndSettle();

          expect(find.byType(ListTile), findsOneWidget);
        },
      );

      testWidgets(
        'GIVEN validator screen, WHEN show screen THEN show screen when validator list is empty',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => ValidationScreenState.initial().copyWith(
              listOfValidatorUsers: [],
              screenStatus: const ScreenStatus.success(),
            ),
          );

          late BuildContext myContext;

          await widgetTester.pumpApp(
            const ValidationScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<ValidationScreenBloc>.value(value: bloc),
            ],
          );
          expect(
            find.text(myContext.localizations.empty_validator_text),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN error screen, WHEN show screen THEN show error page',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => ValidationScreenState.initial().copyWith(
              listOfValidatorUsers: [],
              screenStatus: const ScreenStatus.error(),
            ),
          );

          late BuildContext myContext;

          await widgetTester.pumpApp(
            const ValidationScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<ValidationScreenBloc>.value(value: bloc),
            ],
          );
          expect(
            find.text(myContext.localizations.empty_validator_text),
            findsOneWidget,
          );
        },
      );
    },
  );
}
