import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/add_new_authorized_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

import '../../../../data/instruments/request_data_instruments.dart';
import '../../../../instruments/widgets_instruments.dart';
import '../../../instruments/pump_app.dart';
import 'add_new_authorized_screen_test.mocks.dart';

@GenerateMocks([AuthorizationScreenBloc, UsersSearchBloc])
void main() {
  late MockAuthorizationScreenBloc authorizationBloc;
  late MockUsersSearchBloc searchBloc;
  late BuildContext myContext;

  setUp(() {
    authorizationBloc = MockAuthorizationScreenBloc();
    searchBloc = MockUsersSearchBloc();
    when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
    when(searchBloc.stream).thenAnswer((_) => const Stream.empty());
    when(authorizationBloc.state).thenAnswer(
      (_) => AuthorizationScreenState.initial().copyWith(
        screenStatus: const ScreenStatus.success(),
        listOfAuthorizations: givenAuthDataList(),
        listOfAuthorizationsSend: givenAuthDataSendList(),
        listOfAuthorizationsReceived: givenAuthDataReceivedList(),
      ),
    );
    when(searchBloc.state).thenAnswer((_) => UsersSearchState.initial());
  });

  Future<void> pumpWidgetWithBloc(WidgetTester tester) async {
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthorizationScreenBloc>.value(
            value: authorizationBloc,
          ),
          BlocProvider<UsersSearchBloc>.value(
            value: searchBloc,
          ),
        ],
        child: Builder(
          builder: (context) {
            myContext = context;

            return const AddNewAuthorized();
          },
        ),
      ),
    );
  }

  testWidgets(
    'GIVEN a name WHEN use the Search THEN select one',
    (tester) async {
      await pumpWidgetWithBloc(tester);

      expect(find.byType(AFSearch), findsOneWidget);
      await tester.tap(find.byType(AFSearch));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(AFSearch), WidgetsInstruments.searchNewAuthorized,);
      await tester.pump();
      await tester.tap(find.text(WidgetsInstruments.searchNewAuthorized));
      expect(find.text(WidgetsInstruments.searchNewAuthorized), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN a date WHEN use the DateInput THEN select one',
    (tester) async {
      await pumpWidgetWithBloc(tester);

      expect(
        find.widgetWithText(
          AFDateInput,
          myContext.localizations.date_start_text,
        ),
        findsOneWidget,
      );
      await tester.tap(
        find.widgetWithText(
          AFDateInput,
          myContext.localizations.date_start_text,
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('19'));
      await tester.pumpAndSettle();
      expect(find.text('19'), findsOneWidget);
      await tester.tap(
        find.widgetWithText(
          AFDateInput,
          myContext.localizations.date_start_text,
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      expect(find.text('20'), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN a type WHEN click on Delegate Button THEN return the true value',
    (tester) async {
      await pumpWidgetWithBloc(tester);
      final substitute = tester.widget<AFRadioButton>(find.widgetWithText(
        AFRadioButton,
        myContext.localizations.delegate_user_text,
      ));
      await tester.tap(find.text(myContext.localizations.delegate_user_text));
      await tester.pumpAndSettle();
      final delegate = tester.widget<AFRadioButton>(find.widgetWithText(
        AFRadioButton,
        myContext.localizations.delegate_user_text,
      ));
      expect(substitute.value, false);
      expect(delegate.value, true);
    },
  );
  testWidgets(
    'GIVEN a type WHEN click on Substitute Button THEN return the true value',
    (tester) async {
      await pumpWidgetWithBloc(tester);
      final delegate = tester.widget<AFRadioButton>(find.widgetWithText(
        AFRadioButton,
        myContext.localizations.delegate_user_text,
      ));
      final substitute = tester.widget<AFRadioButton>(find.widgetWithText(
        AFRadioButton,
        myContext.localizations.substitute_user_text,
      ));
      await tester.tap(find.text(myContext.localizations.substitute_user_text));
      await tester.pump();

      expect(substitute.value, true);
      expect(delegate.value, false);
    },
  );

  testWidgets(
    'GIVEN a text WHEN use the AFTextInbox THEN select find the content',
    (tester) async {
      await pumpWidgetWithBloc(tester);

      expect(find.byType(AFTextInbox), findsOneWidget);
      await tester.tap(find.byType(AFTextInbox), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(AFTextInbox), WidgetsInstruments.testText,);
      await tester.pump();
      expect(find.text(WidgetsInstruments.testText), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN a update state WHEN click on back button THEN expect events clearResult and loadUsers',
    (tester) async {
      await pumpWidgetWithBloc(tester);
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
      when(authorizationBloc.state).thenAnswer(
        (_) => AuthorizationScreenState.initial().copyWith(
          screenStatus: const ScreenStatus.success(),
          newAuthorization: newUserEntityTest(),
        ),
      );
      await tester.tap(find.byType(ExpandedButton));
      await tester.pumpAndSettle();
      expect(authorizationBloc.state.screenStatus.isSuccess(), true);
    },
  );
}
