import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/home_screen.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/select_profile/profiles_error_component.dart';
import 'package:portafirmas_app/presentation/features/home/select_profile/select_profile_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/requests_screen_provider.dart';
import 'package:portafirmas_app/presentation/features/initial_access/access_screen.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';

import '../../../data/instruments/request_data_instruments.dart';
import '../../instruments/pump_app.dart';
import '../../instruments/requests_instruments.dart';
import 'home_screen_test.mocks.dart';

@GenerateMocks([
  ProfileBloc,
  GoRouter,
  RequestsBloc,
  PushBloc,
  AuthorizationScreenBloc,
  MultiSelectionRequestBloc,
  AuthBloc,
  CertificatesHandleBloc,
  SplashBloc,
])
void main() {
  late MockProfileBloc bloc;
  late MockGoRouter mockGoRouter;
  late MockRequestsBloc mockRequestBloc;
  late MockPushBloc mockPushBloc;
  late MockAuthorizationScreenBloc authorizationBloc;
  late MockMultiSelectionRequestBloc multiSelection;
  late MockAuthBloc authBloc;
  late MockCertificatesHandleBloc certificatesHandleBloc;
  late MockSplashBloc mockSplashBloc;

  setUp(() {
    bloc = MockProfileBloc();
    mockGoRouter = MockGoRouter();
    mockRequestBloc = MockRequestsBloc();
    mockPushBloc = MockPushBloc();
    authorizationBloc = MockAuthorizationScreenBloc();
    multiSelection = MockMultiSelectionRequestBloc();
    authBloc = MockAuthBloc();
    certificatesHandleBloc = MockCertificatesHandleBloc();
    mockSplashBloc = MockSplashBloc();
  });

  group('Home screen test', () {
    testWidgets(
      'GIVEN Home screen WHEN show the screen THEN load user profile roles',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(authBloc.stream).thenAnswer((_) => const Stream.empty());
        when(authBloc.state).thenReturn(
          const AuthState(
            screenStatus: ScreenStatus.success(),
            userAuthStatus: UserAuthStatus.loggedIn(
              dni: '12345678A',
              loggedWithClave: false,
            ),
            isWelcomeTourFinished: true,
          ),
        );
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => ProfileState.initial().copyWith(
            profiles: givenUserRolesList(),
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
        when(mockRequestBloc.state).thenAnswer((_) => RequestsState.initial());
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockGoRouter.go(
          RoutePath.requestsScreen,
        )).thenAnswer((realInvocation) => const RequestsScreenProvider());

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const HomeScreen(
            isChangeProfileScreen: false,
            biometricsTest: true,
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<ProfileBloc>.value(value: bloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<RequestsBloc>.value(
              value: mockRequestBloc,
            ),
          ],
          router: mockGoRouter,
        );

        expect(find.byType(SelectProfileSection), findsOneWidget);
        await widgetTester.tap(find.text(
          '${myContext.localizations.validator_of_user_text}${givenUserRolesList().first.userName}',
        ));
        await widgetTester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.general_continue),
          findsOneWidget,
        );
        await widgetTester
            .tap(find.text(myContext.localizations.general_continue));
        await widgetTester.pumpAndSettle();
      },
    );

    testWidgets(
      'GIVEN Home screen WHEN tap in back button THEN logout',
      (widgetTester) async {
        final authStates = <AuthState>[
          const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.loggedIn(
              dni: '12345678A',
              loggedWithClave: false,
            ),
            isWelcomeTourFinished: true,
          ),
          const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.unidentified(),
            isWelcomeTourFinished: true,
          ),
        ];
        final authStatesStream = <AuthState>[
          const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.loggedIn(
              dni: '12345678A',
              loggedWithClave: false,
            ),
            isWelcomeTourFinished: true,
          ),
          const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.unidentified(),
            isWelcomeTourFinished: true,
          ),
        ];
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authBloc.stream)
            .thenAnswer((_) => Stream.fromIterable(authStatesStream));
        when(mockPushBloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(mockSplashBloc.stream).thenAnswer((_) => const Stream.empty());

        when(mockSplashBloc.state).thenAnswer(
          (_) => const SplashState.splashed(
            welcomeTourIsFinished: true,
            isFirstTime: true,
          ),
        );

        when(authBloc.add(any)).thenReturn(null);
        when(mockPushBloc.add(any)).thenReturn(null);
        when(mockSplashBloc.add(any)).thenReturn(null);
        when(authorizationBloc.add(any)).thenReturn(null);
        when(certificatesHandleBloc.add(any)).thenReturn(null);
        when(bloc.add(any)).thenReturn(null);

        when(authBloc.state).thenAnswer((realInvocation) {
          final auth = authStates.removeAt(0);

          return auth;
        });

        when(bloc.state).thenAnswer(
          (_) => ProfileState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
          ),
        );
        when(mockGoRouter.go(
          RoutePath.accessScreen,
        )).thenAnswer(
          (realInvocation) => const AccessScreen(),
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

        when(authBloc.state).thenAnswer(
          (_) => const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.loggedIn(
              dni: '12345678A',
              loggedWithClave: false,
            ),
            isWelcomeTourFinished: true,
          ),
        );

        when(bloc.state).thenAnswer(
          (_) => ProfileState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
          ),
        );
        when(mockGoRouter.go(
          RoutePath.accessScreen,
        )).thenAnswer(
          (realInvocation) => const AccessScreen(),
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

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const HomeScreen(
            isChangeProfileScreen: false,
            biometricsTest: true,
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<ProfileBloc>.value(value: bloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<PushBloc>.value(value: mockPushBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<SplashBloc>.value(
              value: mockSplashBloc,
            ),
          ],
          router: mockGoRouter,
        );

        await widgetTester.tap(find.bySemanticsLabel(
          MaterialLocalizations.of(myContext).backButtonTooltip,
        ));
        await widgetTester.pumpAndSettle(const Duration(seconds: 1));

        verify(mockGoRouter.go(
          RoutePath.accessScreen,
        )).called(1);
      },
    );

    testWidgets( 
      'GIVEN Home screen WHEN error loading user roles THEN show error screen',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authBloc.stream).thenAnswer((_) => const Stream.empty());
        when(authBloc.state).thenReturn(
          const AuthState(
            screenStatus: ScreenStatus.initial(),
            userAuthStatus: UserAuthStatus.loggedIn(
              dni: '12345678A',
              loggedWithClave: false,
            ),
            isWelcomeTourFinished: true,
          ),
        );
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());

        when(bloc.state).thenAnswer(
          (_) => ProfileState.initial().copyWith(
            screenStatus: const ScreenStatus.error(),
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

        await widgetTester.pumpApp(
          const HomeScreen(
            isChangeProfileScreen: false,
            biometricsTest: true,
          ),
          providers: [
            BlocProvider<ProfileBloc>.value(value: bloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
          ],
        );

        expect(
          find.byType(ProfilesErrorComponent),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN Home screen provider WHEN user is signer THEN signed tab will be shown',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());

        when(bloc.state).thenAnswer(
          (_) => ProfileState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            selectedProfile: null,
          ),
        );
        when(mockRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockRequestBloc.state).thenAnswer(
          (_) => RequestsState.initial().copyWith(
            isSigner: true,
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
        when(mockPushBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockPushBloc.state)
            .thenAnswer((realInvocation) => const PushState.idle());

        when(mockPushBloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockPushBloc.state)
            .thenAnswer((realInvocation) => const PushState.idle());

        when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.state).thenAnswer(
          (_) => MultiSelectionRequestState.initial().copyWith(
            isButtonEnabled: false,
            isSelected: false,
            selectedRequests: {},
            showCheckbox: false,
          ),
        );

        when(certificatesHandleBloc.state).thenAnswer(
          (_) => CertificatesHandleState.initial(),
        );

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const RequestsScreenProvider(),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<ProfileBloc>.value(value: bloc),
            BlocProvider<RequestsBloc>.value(value: mockRequestBloc),
            BlocProvider<PushBloc>.value(value: mockPushBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: multiSelection,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
          ],
        );

        expect(
          find.text(myContext.localizations.signed_tab_text),
          findsOneWidget,
        );
      },
    );
  });
}
