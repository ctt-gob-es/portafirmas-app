import 'package:app_factory_ui/buttons/af_button/button_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/di/di.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_controller.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_screen.dart';
import 'package:portafirmas_app/presentation/features/splash/widgets/required_update_screen.dart';

import '../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'splash_controller_test.mocks.dart';

@GenerateMocks([
  SplashBloc,
  AppVersionBloc,
])
void main() async {
  FlutterSecureStorage.setMockInitialValues({
    WidgetsInstruments.welcomeKey: 'false',
  });
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  late MockAppVersionBloc appVersionBloc;
  late MockSplashBloc splashBloc;
  late MockFlutterSecureStorage secureStorage;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('path');
    secureStorage = MockFlutterSecureStorage();
    await initDi(secureStorage: secureStorage);

    splashBloc = MockSplashBloc();
    appVersionBloc = MockAppVersionBloc();
  });

  group('Splash controller test', () {
    testWidgets(
      'GIVEN a SplashController WHEN the state is initial() THEN I will get a SplashScreen',
      (widgetTester) async {
        when(splashBloc.stream).thenAnswer((_) => const Stream.empty());
        when(splashBloc.state).thenAnswer((_) => const SplashState.initial());
        when(appVersionBloc.stream).thenAnswer((_) => const Stream.empty());
        when(appVersionBloc.state).thenAnswer((realInvocation) =>
            const AppVersionState.upToDateVersion(appVersion: '2.0'));

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SplashBloc>.value(
                  value: splashBloc,
                ),
                BlocProvider<AppVersionBloc>.value(
                  value: appVersionBloc,
                ),
              ],
              child: const SplashController(),
            ),
          ),
        );

        expect(find.byType(SplashScreen), findsOneWidget);
      },
    );
    debugDefaultTargetPlatformOverride = null;

    testWidgets(
      'GIVEN a SplashController WHEN the AppVersionState is requiredUpdateVersion THEN I will get a RequiredUpdateScreen',
      (tester) async {
        when(splashBloc.stream).thenAnswer((_) => const Stream.empty());
        when(splashBloc.state).thenAnswer((_) => const SplashState.initial());
        when(appVersionBloc.stream).thenAnswer((_) => const Stream.empty());
        when(appVersionBloc.state).thenAnswer(
          (realInvocation) => const AppVersionState.requiredUpdateVersion(
            appVersion: '2.0',
            minVersion: '2.3',
          ),
        );

        await tester.pumpWidget(
          LocalizationsInj(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SplashBloc>.value(
                  value: splashBloc,
                ),
                BlocProvider<AppVersionBloc>.value(
                  value: appVersionBloc,
                ),
              ],
              child: Builder(builder: (context) {
                return const SplashController();
              }),
            ),
          ),
        );

        expect(find.byType(RequiredUpdateScreen), findsOneWidget);

        await tester.tap(find.byType(AFButton));
        await tester.pumpAndSettle();
      },
    );
  });
}
