import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/initial_access/access_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/settings_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_section.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';

import '../../../data/instruments/request_data_instruments.dart';
import '../../instruments/pump_app.dart';
import '../../instruments/requests_instruments.dart';
import 'settings_screen_test.mocks.dart';

@GenerateMocks(
  [
    AuthBloc,
    PushBloc,
    ProfileBloc,
    AppVersionBloc,
    GoRouter,
    AuthorizationScreenBloc,
    CertificatesHandleBloc,
    SplashBloc,
  ],
)
void main() {
  late MockAuthBloc authBloc;
  late MockPushBloc pushNotificationBloc;
  late MockProfileBloc profileBloc;
  late MockAppVersionBloc appVersionBloc;
  late MockAuthorizationScreenBloc authorizationBloc;
  late MockGoRouter mockGoRouter;
  late MockCertificatesHandleBloc certificatesHandleBloc;
  late MockSplashBloc mockSplashBloc;
  late BuildContext myContext;

  setUpAll(() {
    authBloc = MockAuthBloc();
    pushNotificationBloc = MockPushBloc();
    profileBloc = MockProfileBloc();
    authorizationBloc = MockAuthorizationScreenBloc();
    certificatesHandleBloc = MockCertificatesHandleBloc();
    appVersionBloc = MockAppVersionBloc();
    mockGoRouter = MockGoRouter();
    mockSplashBloc = MockSplashBloc();
  });

  group(
    'Settings screen test',
    () {
      testWidgets(
        'GIVEN a Settings screen WHEN screen is shown, THEN load profile model helper sections ',
        (widgetTester) async {
          when(authBloc.stream).thenAnswer((_) => const Stream.empty());
          when(pushNotificationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(profileBloc.stream).thenAnswer((_) => const Stream.empty());
          when(authorizationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(certificatesHandleBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(appVersionBloc.stream).thenAnswer((_) => const Stream.empty());

          when(pushNotificationBloc.state).thenAnswer(
            (_) => const PushState.idle(),
          );
          when(authBloc.state).thenAnswer(
            (_) => AuthState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(profileBloc.state).thenAnswer(
            (_) => ProfileState.initial().copyWith(
              profiles: givenUserRolesList(),
              selectedProfile: null,
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(authorizationBloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              listOfAuthorizations: givenAuthDataList(),
              listOfAuthorizationsSend: givenAuthDataSendList(),
              listOfAuthorizationsReceived: givenAuthDataReceivedList(),
            ),
          );
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial(),
          );
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial().copyWith(
              defaultCertificate: certificate,
            ),
          );
          when(appVersionBloc.state).thenAnswer((realInvocation) =>
              const AppVersionState.upToDateVersion(appVersion: '2.0'));

          await widgetTester.pumpApp(
            const SettingsScreen(),
            onGetContext: (context) => context,
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<PushBloc>.value(
                value: pushNotificationBloc,
              ),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<AuthorizationScreenBloc>.value(
                value: authorizationBloc,
              ),
              BlocProvider<CertificatesHandleBloc>.value(
                value: certificatesHandleBloc,
              ),
              BlocProvider<AppVersionBloc>.value(
                value: appVersionBloc,
              ),
            ],
          );

          expect(
            find.byType(ProfileTemplateSection),
            findsWidgets,
          );
        },
      );

      testWidgets(
        'GIVEN a Settings screen WHEN screen is shown, THEN show notification toggle',
        (widgetTester) async {
          when(authBloc.stream).thenAnswer((_) => const Stream.empty());
          when(pushNotificationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(profileBloc.stream).thenAnswer((_) => const Stream.empty());
          when(authorizationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(certificatesHandleBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(appVersionBloc.stream).thenAnswer((_) => const Stream.empty());
          when(pushNotificationBloc.state).thenAnswer(
            (_) => const PushState.idle(),
          );
          when(authBloc.state).thenAnswer(
            (_) => AuthState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(profileBloc.state).thenAnswer(
            (_) => ProfileState.initial().copyWith(
              profiles: givenUserRolesList(),
              selectedProfile: null,
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(authorizationBloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              listOfAuthorizations: givenAuthDataList(),
              listOfAuthorizationsSend: givenAuthDataSendList(),
              listOfAuthorizationsReceived: givenAuthDataReceivedList(),
            ),
          );
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial(),
          );
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial().copyWith(
              defaultCertificate: certificate,
            ),
          );
          when(appVersionBloc.state).thenAnswer((realInvocation) =>
              const AppVersionState.recommendedUpdateVersion(
                appVersion: '2.0',
              ));

          late BuildContext myContext;

          await widgetTester.pumpApp(
            const SettingsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<PushBloc>.value(
                value: pushNotificationBloc,
              ),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<AuthorizationScreenBloc>.value(
                value: authorizationBloc,
              ),
              BlocProvider<CertificatesHandleBloc>.value(
                value: certificatesHandleBloc,
              ),
              BlocProvider<AppVersionBloc>.value(
                value: appVersionBloc,
              ),
            ],
          );

          await widgetTester.tap(find.text(
            myContext.localizations.push_notifications_text,
          ));
          await widgetTester.pumpAndSettle();
        },
      );

      testWidgets(
        'GIVEN log out button in settings screen, WHEN I tap THEN logs out',
        (widgetTester) async {
          when(authBloc.stream).thenAnswer((_) => const Stream.empty());
          when(pushNotificationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(profileBloc.stream).thenAnswer((_) => const Stream.empty());
          when(authorizationBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(certificatesHandleBloc.stream)
              .thenAnswer((_) => const Stream.empty());
          when(appVersionBloc.stream).thenAnswer((_) => const Stream.empty());
          when(mockSplashBloc.stream).thenAnswer((_) => const Stream.empty());

          when(mockSplashBloc.state).thenAnswer(
            (_) => const SplashState.splashed(
              welcomeTourIsFinished: true,
              isFirstTime: true,
            ),
          );

          when(pushNotificationBloc.state).thenAnswer(
            (_) => const PushState.idle(),
          );
          when(authBloc.state).thenAnswer(
            (_) => AuthState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(profileBloc.state).thenAnswer(
            (_) => ProfileState.initial().copyWith(
              profiles: givenUserRolesList(),
              selectedProfile: null,
              screenStatus: const ScreenStatus.success(),
            ),
          );
          when(authorizationBloc.state).thenAnswer(
            (_) => AuthorizationScreenState.initial().copyWith(
              screenStatus: const ScreenStatus.success(),
              listOfAuthorizations: givenAuthDataList(),
              listOfAuthorizationsSend: givenAuthDataSendList(),
              listOfAuthorizationsReceived: givenAuthDataReceivedList(),
            ),
          );
          when(mockGoRouter.go(
            RoutePath.accessScreen,
          )).thenAnswer((realInvocation) => const AccessScreen());
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial(),
          );
          when(certificatesHandleBloc.state).thenAnswer(
            (_) => CertificatesHandleState.initial().copyWith(
              defaultCertificate: certificate,
            ),
          );
          when(appVersionBloc.state).thenAnswer(
            (realInvocation) => const AppVersionState.requiredUpdateVersion(
              appVersion: '2.0',
              minVersion: '2.1',
            ),
          );

          await widgetTester.pumpApp(
            const SettingsScreen(),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<PushBloc>.value(
                value: pushNotificationBloc,
              ),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<AuthorizationScreenBloc>.value(
                value: authorizationBloc,
              ),
              BlocProvider<CertificatesHandleBloc>.value(
                value: certificatesHandleBloc,
              ),
              BlocProvider<AppVersionBloc>.value(
                value: appVersionBloc,
              ),
              BlocProvider<SplashBloc>.value(
                value: mockSplashBloc,
              ),
            ],
            router: mockGoRouter,
          );

          final logOutButton = find.text(myContext.localizations.logout_text);
          await widgetTester.ensureVisible(logOutButton);
          await widgetTester.tap(logOutButton, warnIfMissed: false);
          await widgetTester.pumpAndSettle();
        },
      );
    },
  );
}
