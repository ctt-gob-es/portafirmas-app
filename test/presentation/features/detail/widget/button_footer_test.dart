import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/buttons_footer.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

import '../../../../instruments/widgets_instruments.dart';
import '../../../instruments/pump_app.dart';
import '../../../instruments/requests_instruments.dart';
import 'button_footer_test.mocks.dart';

@GenerateMocks([
  RequestRepositoryContract,
  SignBloc,
  GoRouter,
  CertificatesHandleBloc,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockRequestRepositoryContract requestRepositoryContract;
  late DetailRequestBloc detailRequestBloc;
  late CertificatesHandleBloc certificatesHandleBloc;
  late ProfileBloc profileBloc;
  late MockSignBloc signBloc;
  late MockGoRouter goRouter;
  late BuildContext myContext;

  setUp(() {
    requestRepositoryContract = MockRequestRepositoryContract();
    detailRequestBloc =
        DetailRequestBloc(repositoryContract: requestRepositoryContract);
    profileBloc = ProfileBloc(repositoryContract: requestRepositoryContract);
    signBloc = MockSignBloc();
    certificatesHandleBloc = MockCertificatesHandleBloc();
    goRouter = MockGoRouter();
  });

  group('Sign process ', () {
    testWidgets(
      'GIVEN the detail screen WHEN click on Sign button THEN display the sign modal',
      (tester) async {
        when(goRouter.pop()).thenAnswer((realInvocation) => ButtonsFooter(
              request: WidgetsInstruments.givenDetailRequestEntity(),
            ));
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        late BuildContext myContext;
        await tester.pumpApp(
          ButtonsFooter(
            request: WidgetsInstruments.givenDetailRequestEntity(),
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<DetailRequestBloc>.value(
              value: detailRequestBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBloc
                ..emit(
                  const ProfileState(
                    profiles: [],
                    selectedProfile: null,
                    screenStatus: ScreenStatus.success(),
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(value: signBloc),
          ],
          router: goRouter,
        );

        await tester.tap(
          find.text(myContext.localizations.generic_button_sign),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text(myContext.localizations.generic_button_sign).last,
          warnIfMissed: false,
        );

        expect(
          find.byType(ModalTemplate),
          findsWidgets,
        );
      },
    );
  });
  group('Validate process', () {
    testWidgets(
      'GIVEN the showModalValidate WHEN click on Validate button THEN display the modals',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial().copyWith(
              screenStatus: const ScreenStatus.loading(),
              action: ActionType.validate,
            ));
        when(signBloc.state).thenReturn(
          const SignState(
            action: ActionType.validate,
            screenStatus: ScreenStatus.success(),
            isSingleRequest: true,
          ),
        );
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());

        await tester.pumpApp(
          ButtonsFooter(
            request: WidgetsInstruments.givenDetailRequestEntity(),
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<DetailRequestBloc>.value(
              value: detailRequestBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBloc
                ..emit(
                  ProfileState(
                    profiles: givenUserRolesList(),
                    selectedProfile: givenUserRolesList().first,
                    screenStatus: const ScreenStatus.success(),
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(
              value: signBloc
                ..emit(
                  const SignState(
                    action: ActionType.validate,
                    screenStatus: ScreenStatus.success(),
                    isSingleRequest: true,
                  ),
                ),
            ),
          ],
          router: goRouter,
        );

        await tester.tap(
          find.text(myContext.localizations.generic_button_validate),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            myContext.localizations.validate_module_subtitle,
          ),
          findsOneWidget,
        );
        await tester.tap(
          find.text(myContext.localizations.generic_button_validate).last,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        verify(
          signBloc.add(
            SignEvent.validateRequests(
              requestIds: [WidgetsInstruments.givenDetailRequestEntity().id],
            ),
          ),
        );
      },
    );

    testWidgets(
      'GIVEN the showModalValidate WHEN click on Validate button THEN click on Cancel button to go back',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
        when(signBloc.state)
            .thenAnswer((realInvocation) => SignState.initial().copyWith(
                  screenStatus: const ScreenStatus.loading(),
                  action: ActionType.validate,
                ));

        when(signBloc.state).thenReturn(
          const SignState(
            action: ActionType.validate,
            screenStatus: ScreenStatus.success(),
            isSingleRequest: true,
          ),
        );
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());

        await tester.pumpApp(
          ButtonsFooter(
            request: WidgetsInstruments.givenDetailRequestEntity(),
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<DetailRequestBloc>.value(
              value: detailRequestBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBloc
                ..emit(
                  ProfileState(
                    profiles: givenUserRolesList(),
                    selectedProfile: givenUserRolesList().first,
                    screenStatus: const ScreenStatus.success(),
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(
              value: signBloc,
            ),
          ],
          router: goRouter,
        );

        await tester.tap(
          find.text(myContext.localizations.generic_button_validate),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
        expect(
          find.text(myContext.localizations.general_cancel),
          findsOneWidget,
        );
        await tester.tap(
          find.text(myContext.localizations.general_cancel),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
        expect(
          find.text(myContext.localizations.generic_button_validate).first,
          findsOneWidget,
        );
      },
    );
  });

  group('Reject process', () {
    testWidgets(
      'GIVEN the reject button WHEN click on Reject THEN display the modal',
      (tester) async {
        when(goRouter.pop()).thenAnswer((realInvocation) => ButtonsFooter(
              request: WidgetsInstruments.givenDetailRequestEntity(),
            ));
        when(signBloc.stream)
            .thenAnswer((realInvocation) => const Stream.empty());
        when(signBloc.state)
            .thenAnswer((realInvocation) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        late BuildContext myContext;
        await tester.pumpApp(
          ButtonsFooter(
            request: WidgetsInstruments.givenDetailRequestEntity(),
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<DetailRequestBloc>.value(
              value: detailRequestBloc,
            ),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBloc
                ..emit(
                  const ProfileState(
                    profiles: [],
                    selectedProfile: null,
                    screenStatus: ScreenStatus.success(),
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(value: signBloc),
          ],
          router: goRouter,
        );

        expect(
          find.text(myContext.localizations.generic_button_reject),
          findsOneWidget,
        );
        await tester.tap(
          find.text(myContext.localizations.generic_button_reject),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
        expect(
          find.text(myContext.localizations.request_reject_module_title),
          findsOneWidget,
        );

        await tester.tap(
          find.text(myContext.localizations.generic_button_reject).last,
          warnIfMissed: false,
        );
      },
    );
  });
}
