import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/authorization_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/widgets/authorization_received_section.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/widgets/authorization_sended_section.dart';

import '../../../../data/instruments/request_data_instruments.dart';
import '../../../instruments/pump_app.dart';
import 'authorization_screen_test.mocks.dart';

@GenerateMocks([AuthorizationScreenBloc])
void main() {
  late MockAuthorizationScreenBloc bloc;
  setUp(() {
    bloc = MockAuthorizationScreenBloc();
  });

  group(
    'Authorization screen test',
    () {
      testWidgets(
        'GIVEN authorization screen, WHEN show screen THEN load authorization send and received tabs',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              listOfAuthorizations: givenAuthDataList(),
              listOfAuthorizationsSend: givenAuthDataSendList(),
              listOfAuthorizationsReceived: givenAuthDataReceivedList(),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const AuthorizationsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(AuthorizationReceived), findsOneWidget);
          await widgetTester.tap(find.text(
            myContext.localizations.petition_send_text,
          ));
          await widgetTester.pumpAndSettle();
          expect(find.byType(AuthorizationSend), findsOneWidget);
        },
      );

      testWidgets(
        'GIVEN authorization screen, WHEN show screen THEN load authorization section when is empty',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              listOfAuthorizations: [],
              listOfAuthorizationsSend: [],
              listOfAuthorizationsReceived: [],
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const AuthorizationsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthorizationScreenBloc>.value(value: bloc),
            ],
          );

          expect(find.byType(AuthorizationReceived), findsOneWidget);
          await widgetTester.tap(find.text(
            myContext.localizations.petition_send_text,
          ));
          await widgetTester.pumpAndSettle();
          expect(find.byType(AuthorizationSend), findsOneWidget);
        },
      );
    },
  );
}
