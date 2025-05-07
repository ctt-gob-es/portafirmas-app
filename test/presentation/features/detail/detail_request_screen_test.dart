import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/sign_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/buttons_footer.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/signed_documents.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/detail_request_screen.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';

import '../../../instruments/localization_injector.dart';
import '../../../instruments/widgets_instruments.dart';
import 'detail_request_screen_test.mocks.dart';

@GenerateMocks([
  RequestRepositoryContract,
  SignRepositoryContract,
  CertificatesHandleBloc,
])
void main() {
  late MockRequestRepositoryContract requestRepositoryContract;
  late MockSignRepositoryContract signRepositoryContract;
  late DetailRequestBloc detailRequestBloc;
  late DocumentBloc documentBloc;
  late ProfileBloc profileBloc;
  late SignBloc signBloc;
  late BuildContext myContext;
  late Widget widget;
  late MockCertificatesHandleBloc certificatesHandleBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    requestRepositoryContract = MockRequestRepositoryContract();
    signRepositoryContract = MockSignRepositoryContract();
    certificatesHandleBloc = MockCertificatesHandleBloc();
    detailRequestBloc =
        DetailRequestBloc(repositoryContract: requestRepositoryContract);
    profileBloc = ProfileBloc(repositoryContract: requestRepositoryContract);
    documentBloc = DocumentBloc(repositoryContract: requestRepositoryContract);
    signBloc = SignBloc(
      repositoryContract: requestRepositoryContract,
      signRepositoryContract: signRepositoryContract,
    );
    widget = MultiBlocProvider(
      providers: [
        BlocProvider<DetailRequestBloc>.value(
          value: detailRequestBloc
            ..emit(
              DetailRequestState(
                screenStatus: const ScreenStatus.success(),
                loadContent: WidgetsInstruments.detailRequestResponse(
                  WidgetsInstruments.fall,
                ),
                isFooterActive: true,
              ),
            ),
        ),
        BlocProvider<ProfileBloc>.value(value: profileBloc),
        BlocProvider<DocumentBloc>.value(value: documentBloc),
      ],
      child: LocalizationsInj(
        child: Builder(
          builder: (context) {
            myContext = context;

            return const DetailRequestScreen(
              requestStatus: RequestStatus.signed,
            );
          },
        ),
      ),
    );
  });

  testWidgets(
    'GIVEN DetailRequestScreen WHEN receive a signed state THEN find the CircularProgressIndicator at first',
    (tester) async {
      await tester.pumpWidget(BlocProvider<DetailRequestBloc>(
        create: (context) =>
            detailRequestBloc..emit(DetailRequestState.initial()),
        child: LocalizationsInj(
          child: Builder(
            builder: (context) {
              myContext = context;

              return const DetailRequestScreen(
                requestStatus: RequestStatus.signed,
              );
            },
          ),
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN a Detail screen WHEN click on a pending request THEN show the footer buttons',
    (tester) async {
      when(certificatesHandleBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(certificatesHandleBloc.state)
          .thenAnswer((_) => CertificatesHandleState.initial());
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<CertificatesHandleBloc>.value(
            value: certificatesHandleBloc,
          ),
          BlocProvider<DetailRequestBloc>.value(
            value: detailRequestBloc
              ..emit(
                DetailRequestState(
                  screenStatus: const ScreenStatus.success(),
                  loadContent: WidgetsInstruments.detailRequestResponse(
                    WidgetsInstruments.fall,
                  ),
                  isFooterActive: true,
                ),
              ),
          ),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
          BlocProvider<DocumentBloc>.value(value: documentBloc),
          BlocProvider<SignBloc>.value(value: signBloc),
        ],
        child: LocalizationsInj(
          child: Builder(
            builder: (context) {
              myContext = context;

              return const DetailRequestScreen(
                requestStatus: RequestStatus.pending,
              );
            },
          ),
        ),
      ));
      expect(
        find.byType(ButtonsFooter),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GIVEN a Detail screen WHEN click on a pending request THEN show the modals info Sign on SignedDocuments Widget',
    (tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(SignedDocuments), findsWidgets);
      await tester.pumpAndSettle();
      await tester.tap(find.text(myContext.localizations.generic_sign).first);
      await tester.pumpAndSettle();
      expect(
        find.text(myContext.localizations.info_sign_module),
        findsOneWidget,
      );
      await tester.tap(find.text(myContext.localizations.general_understood));
      await tester.pumpAndSettle();
      expect(find.byType(Navigator), findsWidgets);
    },
  );

  testWidgets(
    'GIVEN a Detail screen WHEN click on a pending request THEN show the modals informs Sign on SignedDocuments Widget',
    (tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(SignedDocuments), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.text(myContext.localizations.generic_informs_sign));
      await tester.pumpAndSettle();
      expect(
        find.text(myContext.localizations.info_generic_informs_module),
        findsOneWidget,
      );
      await tester.tap(find.text(myContext.localizations.general_understood));
      await tester.pumpAndSettle();
      expect(find.byType(Navigator), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN Anexe Document WHEN pending request does not have annexes THEN do nothing',
    (tester) async {
      await tester.pumpWidget(widget);
      expect(
        find.text('${myContext.localizations.generic_annexes} (0)'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GIVEN a Detail screen WHEN click on a pending request THEN show the footer buttons',
    (tester) async {
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DetailRequestBloc>.value(
            value: detailRequestBloc
              ..emit(
                DetailRequestState(
                  screenStatus: const ScreenStatus.error(),
                  loadContent: WidgetsInstruments.detailRequestResponse(
                    WidgetsInstruments.fall,
                  ),
                  isFooterActive: true,
                ),
              ),
          ),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
          BlocProvider<DocumentBloc>.value(value: documentBloc),
        ],
        child: LocalizationsInj(
          child: Builder(
            builder: (context) {
              myContext = context;

              return const DetailRequestScreen(
                requestStatus: RequestStatus.pending,
              );
            },
          ),
        ),
      ));
      expect(
        find.text(
          myContext.localizations.request_send_failed,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations.request_send_failed_text,
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(myContext.localizations.general_retry));
      await tester.pumpAndSettle();
      expect(
        find.byType(Navigator),
        findsOneWidget,
      );
    },
  );
}
