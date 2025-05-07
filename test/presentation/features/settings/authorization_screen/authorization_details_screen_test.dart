import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/data_entry.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/authorization_details_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';

import '../../../../data/instruments/request_data_instruments.dart';
import '../../../instruments/pump_app.dart';
import 'authorization_screen_test.mocks.dart';

@GenerateMocks([AuthorizationScreenBloc])
void main() {
  late MockAuthorizationScreenBloc bloc;
  late BuildContext myContext;

  setUp(() {
    bloc = MockAuthorizationScreenBloc();
  });

  group(
    'Authorization details screen test',
    () {
      testWidgets(
        'GIVEN authorization details screen, WHEN show screen THEN load progress indicator',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.loading(),
              listOfAuthorizations: givenAuthDataList(),
              listOfAuthorizationsSend: givenAuthDataSendList(),
              listOfAuthorizationsReceived: givenAuthDataReceivedList(),
            ),
          );

          await widgetTester.pumpApp(
            const AuthorizationDetailsScreen(),
            onGetContext: (context) => context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'GIVEN authorization details screen, test authorization when authorization is revoked',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              authorization: givenAuthDataDetailsList()[0],
            ),
          );

          await widgetTester.pumpApp(
            const AuthorizationDetailsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(DataCardEntry), findsWidgets);

          var dataEntry =
              find.text(myContext.localizations.petition_received_text);
          expect(dataEntry, findsOneWidget);
          await widgetTester.ensureVisible(dataEntry);
        },
      );

      testWidgets(
        'GIVEN authorization details screen, test authorization when authorization is accepted',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              authorization: givenAuthDataDetailsList()[3],
            ),
          );

          await widgetTester.pumpApp(
            const AuthorizationDetailsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(DataCardEntry), findsWidgets);

          var dataEntry =
              find.text(myContext.localizations.petition_received_text);
          expect(dataEntry, findsOneWidget);
        },
      );

      testWidgets(
        'GIVEN authorization details screen, test authorization when authorization is pending',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              authorization: givenAuthDataDetailsList()[5],
            ),
          );

          await widgetTester.pumpApp(
            const AuthorizationDetailsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(DataCardEntry), findsWidgets);

          var declineButton = find.text(myContext.localizations.decline_text);
          expect(declineButton, findsOneWidget);
          await widgetTester.ensureVisible(declineButton);
          await widgetTester.tap(declineButton);
          await widgetTester.pumpAndSettle();

          var acceptButton = find.text(myContext.localizations.accept_text);
          expect(acceptButton, findsOneWidget);
          await widgetTester.ensureVisible(acceptButton);
          await widgetTester.tap(acceptButton);
          await widgetTester.pumpAndSettle();
        },
      );
    },
  );
}
