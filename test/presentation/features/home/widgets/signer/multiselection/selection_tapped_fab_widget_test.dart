import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/multiselection/selection_tapped_fab_widget.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';

import '../../../../../../data/instruments/request_data_instruments.dart';
import '../../../../../instruments/pump_app.dart';
import 'selection_tapped_fab_widget_test.mocks.dart';

@GenerateMocks([
  GoRouter,
  SignBloc,
  CertificatesHandleBloc,
])
void main() {
  late MultiSelectionRequestBloc bloc;
  late MockGoRouter goRouter;
  late MockSignBloc signBloc;
  late BuildContext myContext;
  late MockCertificatesHandleBloc certificatesHandleBloc;

  setUp(() {
    bloc = MultiSelectionRequestBloc();
    signBloc = MockSignBloc();
    goRouter = MockGoRouter();
    certificatesHandleBloc = MockCertificatesHandleBloc();
  });
  group('MultiSelection Validate request', () {
    testWidgets(
      'Select multiple Pending petitions then find the button to validate',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        await tester.pumpApp(
          const MultiSelectionTapFAB(
            isSigner: false,
            requestList: [],
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<SignBloc>.value(value: signBloc),
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: bloc
                ..emit(
                  MultiSelectionRequestState.initial().copyWith(
                    isButtonEnabled: false,
                    isSelected: true,
                    selectedRequests: requestSelected,
                    showCheckbox: false,
                  ),
                ),
            ),
          ],
        );

        expect(
          find.text(myContext.localizations
              .petition_selection_singular(requestSelected.length)),
          findsOneWidget,
        );
        expect(
          find.text(myContext.localizations.generic_button_validate),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Select multiple Pending petitions then click on button to validate and find a the modal',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        await tester.pumpApp(
          const MultiSelectionTapFAB(
            isSigner: false,
            requestList: [],
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: bloc
                ..emit(
                  MultiSelectionRequestState.initial().copyWith(
                    isButtonEnabled: true,
                    isSelected: true,
                    selectedRequests: requestSelected,
                    showCheckbox: false,
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(
              value: signBloc,
            ),
          ],
          router: goRouter,
        );
        await tester
            .tap(find.text(myContext.localizations.generic_button_validate));
        await tester.pumpAndSettle();
        expect(
          find.text(myContext.localizations.validate_module_subtitle),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Select multiple Pending petitions then click on button to validate and find a the modal sign Requests',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        await tester.pumpApp(
          const MultiSelectionTapFAB(
            isSigner: true,
            requestList: [],
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: bloc
                ..emit(
                  MultiSelectionRequestState.initial().copyWith(
                    isButtonEnabled: true,
                    isSelected: true,
                    selectedRequests: requestListSelected,
                    showCheckbox: false,
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(
              value: signBloc,
            ),
          ],
          router: goRouter,
        );

        expect(
          find.text(myContext.localizations
              .petition_selection_plural(requestListSelected.length)),
          findsOneWidget,
        );
        await tester
            .tap(find.text(myContext.localizations.generic_button_sign));
        await tester.pumpAndSettle();
        expect(
          find.text(myContext.localizations.sign_validate_title),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Select multiple Pending petitions then click on button to exit and find a the modal sign Requests',
      (tester) async {
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());
        when(certificatesHandleBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(certificatesHandleBloc.state)
            .thenAnswer((_) => CertificatesHandleState.initial());
        await tester.pumpApp(
          const MultiSelectionTapFAB(
            isSigner: true,
            requestList: [],
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<CertificatesHandleBloc>.value(
              value: certificatesHandleBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: bloc
                ..emit(
                  MultiSelectionRequestState.initial().copyWith(
                    isButtonEnabled: true,
                    isSelected: false,
                    selectedRequests: {},
                    showCheckbox: false,
                  ),
                ),
            ),
            BlocProvider<SignBloc>.value(
              value: signBloc,
            ),
          ],
          router: goRouter,
        );

        expect(find.text(myContext.localizations.exit_text), findsOneWidget);
        await tester.tap(
          find.text(myContext.localizations.exit_text),
          warnIfMissed: false,
        );

      },
    );
  });
}
