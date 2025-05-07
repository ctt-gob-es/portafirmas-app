import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/di/di.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_screen.dart';

import '../../../data/datasources/local_data_source/auth_local_data_source_test.mocks.dart';
import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'splash_screen_test.mocks.dart';

@GenerateMocks([SplashBloc])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFlutterSecureStorage secureStorage;
  late MockSplashBloc bloc;
  FlutterSecureStorage.setMockInitialValues({
    WidgetsInstruments.welcomeKey: 'false',
  });
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  setUpAll(() {
    Hive.init('path');
  });

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    initDi(secureStorage: secureStorage);

    bloc = MockSplashBloc();
  });
  group('Splash screen test', () {
    testWidgets(
      'GIVEN a splash screen WHEN open the app THEN I will get the SVGs of the logos',
      (widgetTester) async {
        when(bloc.state).thenAnswer((_) => const SplashState.initial());

        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: BlocProvider<SplashBloc>.value(
              value: bloc,
              child: const SplashScreen(),
            ),
          ),
        );

        expect(find.byType(SvgPicture), findsWidgets);
      },
    );
    debugDefaultTargetPlatformOverride = null;
  });
}
