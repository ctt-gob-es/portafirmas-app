import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/validator_search_screen.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

import '../../../../data/instruments/request_data_instruments.dart';
import '../../../instruments/pump_app.dart';
import 'validator_search_screen_test.mocks.dart';

@GenerateMocks([UsersSearchBloc, ValidationScreenBloc])
void main() {
  late MockUsersSearchBloc searchBloc;
  late MockValidationScreenBloc validationBloc;
  late BuildContext myContext;
  Color white = const Color(0xFFFFFFFF);
  TextEditingController controller = TextEditingController();

  setUp(() {
    searchBloc = MockUsersSearchBloc();
    validationBloc = MockValidationScreenBloc();
  });

  group('Validator Search screen test', () {
    testWidgets(
      'GIVEN a search bar, WHEN I put a text in field THEN find suggested users that has been searched',
      (widgetTester) async {
        when(validationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(searchBloc.stream).thenAnswer((_) => const Stream.empty());

        when(searchBloc.state)
            .thenAnswer((realInvocation) => UsersSearchState.initial());

        when(validationBloc.state).thenAnswer(
          (_) => ValidationScreenState.initial().copyWith(
            listOfValidatorUsers: givenValidatorUser(),
            screenStatus: const ScreenStatus.success(),
          ),
        );

        when(searchBloc.state).thenAnswer(
          (_) => UsersSearchState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            suggestedUsers: givenValidatorUserBySearch(),
            numberOfResults: givenValidatorUserBySearch().length,
            isButtonEnabled: false,
            isUserAdded: false,
            selectedUser: null,
          ),
        );

        await widgetTester.pumpApp(
          const ValidatorSearchScreen(),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<UsersSearchBloc>.value(value: searchBloc),
            BlocProvider<ValidationScreenBloc>.value(value: validationBloc),
          ],
        );

        //Find searcher

        var searcher = find.text(myContext.localizations.textfield_hint_text);
        expect(searcher, findsOneWidget);
        await widgetTester.ensureVisible(searcher);

        await widgetTester.tap(searcher, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        controller.text = givenValidatorUserBySearch()[0].id;
        controller.text = prueba;

        await widgetTester.enterText(find.byType(AFSearch), controller.text);
        await widgetTester.pumpAndSettle();

        expect(find.text(givenValidatorUserBySearch()[0].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[1].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[2].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[3].name), findsWidgets);
      },
    );

    testWidgets(
      'GIVEN a search bar, WHEN I tap the selected user THEN validator added successfully',
      (widgetTester) async {
        when(validationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(searchBloc.stream).thenAnswer((_) => const Stream.empty());

        when(searchBloc.state)
            .thenAnswer((realInvocation) => UsersSearchState.initial());

        when(validationBloc.state).thenAnswer(
          (_) => ValidationScreenState.initial().copyWith(
            listOfValidatorUsers: givenValidatorUser(),
            screenStatus: const ScreenStatus.success(),
          ),
        );

        when(searchBloc.state).thenAnswer(
          (_) => UsersSearchState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            selectedUser: givenValidatorUserBySearch()[0],
            isButtonEnabled: true,
            isUserAdded: true,
            numberOfResults: givenValidatorUserBySearch().length,
            suggestedUsers: givenValidatorUserBySearch(),
          ),
        );

        await widgetTester.pumpApp(
          const ValidatorSearchScreen(),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<UsersSearchBloc>.value(value: searchBloc),
            BlocProvider<ValidationScreenBloc>.value(value: validationBloc),
          ],
        );

        //Find searcher

        var searcher = find.text(myContext.localizations.textfield_hint_text);
        expect(searcher, findsOneWidget);
        await widgetTester.ensureVisible(searcher);

        await widgetTester.tap(searcher, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        controller.text = givenValidatorUserBySearch()[0].id;
        controller.text = prueba;

        await widgetTester.enterText(find.byType(AFSearch), controller.text);
        await widgetTester.pumpAndSettle();

        expect(find.text(givenValidatorUserBySearch()[0].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[1].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[2].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[3].name), findsWidgets);

        //Tap selected user

        await widgetTester
            .ensureVisible(find.text(givenValidatorUserBySearch()[0].name));
        await widgetTester.tap(find.text(givenValidatorUserBySearch()[0].name));
        await widgetTester.pumpAndSettle();

        //Test overlay success

        showHelpOverlay(myContext, white, searchBloc.state);
        await widgetTester.pump();
        expect(
          find.byType(ModalTemplate),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN a search bar, WHEN I tap the selected user THEN validator can not be added',
      (widgetTester) async {
        when(validationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(searchBloc.stream).thenAnswer((_) => const Stream.empty());

        when(searchBloc.state)
            .thenAnswer((realInvocation) => UsersSearchState.initial());

        when(validationBloc.state).thenAnswer(
          (_) => ValidationScreenState.initial().copyWith(
            listOfValidatorUsers: givenValidatorUser(),
            screenStatus: const ScreenStatus.success(),
          ),
        );

        when(searchBloc.state).thenAnswer(
          (_) => UsersSearchState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            selectedUser: givenValidatorUserBySearch()[0],
            isButtonEnabled: false,
            isUserAdded: false,
            numberOfResults: givenValidatorUserBySearch().length,
            suggestedUsers: givenValidatorUserBySearch(),
          ),
        );

        await widgetTester.pumpApp(
          const ValidatorSearchScreen(),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<UsersSearchBloc>.value(value: searchBloc),
            BlocProvider<ValidationScreenBloc>.value(value: validationBloc),
          ],
        );

        //Find searcher

        var searcher = find.text(myContext.localizations.textfield_hint_text);
        expect(searcher, findsOneWidget);
        await widgetTester.ensureVisible(searcher);

        await widgetTester.tap(searcher, warnIfMissed: false);
        await widgetTester.pumpAndSettle();

        controller.text = givenValidatorUserBySearch()[0].id;
        controller.text = prueba;

        await widgetTester.enterText(find.byType(AFSearch), controller.text);
        await widgetTester.pumpAndSettle();

        expect(find.text(givenValidatorUserBySearch()[0].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[1].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[2].name), findsWidgets);
        expect(find.text(givenValidatorUserBySearch()[3].name), findsWidgets);

        //Tap selected user

        await widgetTester
            .ensureVisible(find.text(givenValidatorUserBySearch()[0].name));
        await widgetTester.tap(find.text(givenValidatorUserBySearch()[0].name));
        await widgetTester.pumpAndSettle();

        //Test overlay failure

        showHelpOverlayError(myContext, searchBloc.state, '', '');
        await widgetTester.pump();
        expect(
          find.byType(ModalTemplate),
          findsOneWidget,
        );
      },
    );
  });
}
