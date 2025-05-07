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
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/authentication_screen.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/requests_screen_provider.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';

import '../../instruments/pump_app.dart';

import 'authentication_screen_test.mocks.dart';

@GenerateMocks([
  AuthBloc,
  GoRouter,
  CertificatesHandleBloc,
])
void main() {
  late MockAuthBloc bloc;
  late MockGoRouter mockGoRouter;
  late MockCertificatesHandleBloc mockCertHangleBloc;

  setUp(() {
    bloc = MockAuthBloc();
    mockGoRouter = MockGoRouter();
    mockCertHangleBloc = MockCertificatesHandleBloc();
  });

  group('Authentication screen test', () {
    testWidgets(
      'GIVEN Authentication screen WHEN tap on help button THEN show help overlay',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockCertHangleBloc.stream).thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => AuthState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
          ),
        );
        when(mockCertHangleBloc.state).thenAnswer(
          (_) => CertificatesHandleState.initial(),
        );
        when(mockGoRouter.go(
          RoutePath.requestsScreen,
        )).thenAnswer((realInvocation) => const RequestsScreenProvider());

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const AuthenticationScreen(),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<AuthBloc>.value(value: bloc),
            BlocProvider<CertificatesHandleBloc>.value(
              value: mockCertHangleBloc,
            ),
          ],
          router: mockGoRouter,
        );

        expect(
          find.text(myContext.localizations.choose_id_title),
          findsOneWidget,
        );

        await widgetTester.tap(
          find.text(
            myContext.localizations.general_need_help,
          ),
          warnIfMissed: false,
        );
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(
          find
              .text(
                myContext.localizations.general_need_help,
              )
              .last,
          warnIfMissed: false,
        );

        await widgetTester.pump();
        await widgetTester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.general_need_help).last,
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN Authentication screen WHEN screen is loading THEN show loader',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(mockCertHangleBloc.stream).thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => AuthState.initial().copyWith(
            screenStatus: const ScreenStatus.loading(),
            userAuthStatus: const UserAuthStatus.urlLoaded(
              loginData: LoginClaveEntity(url: 'url', cookies: {}),
            ),
          ),
        );
        when(mockCertHangleBloc.state).thenAnswer(
          (_) => CertificatesHandleState.initial(),
        );
        when(mockGoRouter.go(
          RoutePath.requestsScreen,
        )).thenAnswer((realInvocation) => const RequestsScreenProvider());

        await widgetTester.pumpApp(
          const AuthenticationScreen(),
          providers: [
            BlocProvider<AuthBloc>.value(value: bloc),
            BlocProvider<CertificatesHandleBloc>.value(
              value: mockCertHangleBloc,
            ),
          ],
          router: mockGoRouter,
        );

        expect(
          find.byType(LoadingComponent),
          findsOneWidget,
        );
      },
    );
  });
}
