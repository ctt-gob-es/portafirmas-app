import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/di/di.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/onboarding/bloc/bloc/onboarding_bloc.dart';
import 'package:portafirmas_app/presentation/features/onboarding/onboarding_screen.dart';

import '../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'onboarding_screen_test.mocks.dart';

@GenerateMocks([OnBoardingBloc])
void main() async {
  late MockOnBoardingBloc onBoardingBloc;
  late BuildContext myContext;
  late MockFlutterSecureStorage secureStorage;

  FlutterSecureStorage.setMockInitialValues({
    WidgetsInstruments.welcomeKey: 'false',
  });
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('path');
    secureStorage = MockFlutterSecureStorage();
    initDi(secureStorage: secureStorage);

    onBoardingBloc = MockOnBoardingBloc();
  });

  group('onboarding screen test', () {
    testWidgets(
      'GIVEN a OnBoardingScreen WHEN OnBoardingState is initial THEN I will get a Next button',
      (widgetTester) async {
        when(onBoardingBloc.stream).thenAnswer((_) => const Stream.empty());
        when(onBoardingBloc.state).thenAnswer(
          (_) => OnBoardingState.initial(),
        );

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: BlocProvider<OnBoardingBloc>.value(
              value: onBoardingBloc,
              child: Builder(builder: (context) {
                myContext = context;

                return const OnBoardingScreen();
              }),
            ),
          ),
        );

        final button = find.text(myContext.localizations.next_msg);
        //tap first next button
        await widgetTester.ensureVisible(button);
        await widgetTester.tap(button);

        await widgetTester.pumpAndSettle();

        final button2 = find.text(myContext.localizations.next_msg);
        expect(button2, findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN a OnBoardingScreen WHEN OnBoardingState is on the last page THEN I will get a Finalize button',
      (widgetTester) async {
        when(onBoardingBloc.stream).thenAnswer((_) => const Stream.empty());
        when(onBoardingBloc.state).thenAnswer(
          (_) => const OnBoardingState(currentPosition: 2),
        );

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: BlocProvider<OnBoardingBloc>.value(
              value: onBoardingBloc,
              child: Builder(builder: (context) {
                myContext = context;

                return const OnBoardingScreen();
              }),
            ),
          ),
        );

        final button = find.text(myContext.localizations.end_msg);

        expect(button, findsOneWidget);
      },
    );
    debugDefaultTargetPlatformOverride = null;
  });
}
