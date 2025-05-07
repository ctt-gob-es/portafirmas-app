import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/explain_add_certificate_screen.dart';

import '../../instruments/pump_app.dart';

import 'explain_add_certificate_screen_test.mocks.dart';

@GenerateMocks([
  AddCertificateBloc,
])
void main() {
  late MockAddCertificateBloc bloc;

  setUp(() {
    bloc = MockAddCertificateBloc();
  });

  testWidgets(
    'GIVEN add certificate screen WHEN tap on next THEN show all screens',
    (widgetTester) async {
      when(bloc.stream).thenAnswer((_) => const Stream.empty());
      when(bloc.state).thenAnswer(
        (_) => AddCertificateState.initial().copyWith(
          screenStatus: const ScreenStatus.initial(),
        ),
      );

      late BuildContext myContext;

      widgetTester.view.physicalSize = const Size(350, 5000);
      // resets the screen to its original size after the test end
      addTearDown(widgetTester.view.resetPhysicalSize);

      await widgetTester.pumpApp(
        const ExplainAddCertificateScreen(),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<AddCertificateBloc>.value(value: bloc),
        ],
      );

      expect(
        find.text(myContext.localizations.add_certificate_explain_1_title),
        findsOneWidget,
      );

      await widgetTester.tap(find.text(
        myContext.localizations.general_continue,
      ));

      await widgetTester.pump(const Duration(seconds: 1));

      expect(
        find.text(myContext.localizations.general_continue),
        findsOneWidget,
      );
    },
  );
}
