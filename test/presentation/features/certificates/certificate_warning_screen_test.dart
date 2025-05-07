import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificate_status_check.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_warning_screen_android.dart';

import '../../../data/instruments/certificate_instruments.dart';
import '../../instruments/pump_app.dart';

import 'certificate_warning_screen_test.mocks.dart';

@GenerateMocks([
  AddCertificateBloc,
  CertificatesHandleBloc,
])
void main() {
  late MockAddCertificateBloc addCertificateBloc;
  late MockCertificatesHandleBloc certificatesHandleBloc;

  setUp(() {
    addCertificateBloc = MockAddCertificateBloc();
    certificatesHandleBloc = MockCertificatesHandleBloc();
  });

  testWidgets(
    'GIVEN certificate warning WHEN attempts is 1 THEN show warning',
    (widgetTester) async {
      when(addCertificateBloc.stream).thenAnswer((_) => const Stream.empty());
      when(certificatesHandleBloc.stream)
          .thenAnswer((_) => const Stream.empty());

      when(addCertificateBloc.state).thenAnswer(
        (_) => const AddCertificateState(
          screenStatus: ScreenStatus.initial(),
        ),
      );

      when(certificatesHandleBloc.state).thenAnswer(
        (_) => CertificatesHandleState(
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.initial(),
          certificateCheck: const CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 1,
        ),
      );

      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertificatesWarningScreenAndroid(),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<AddCertificateBloc>.value(value: addCertificateBloc),
          BlocProvider<CertificatesHandleBloc>.value(
            value: certificatesHandleBloc,
          ),
        ],
      );

      expect(
        find.text(myContext.localizations
            .certificate_warning_has_certificates_installed_title),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations
            .certificate_warning_has_certificates_installed_subtitle),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GIVEN certificate warning WHEN attempts is 2 THEN show error',
    (widgetTester) async {
      when(addCertificateBloc.stream).thenAnswer((_) => const Stream.empty());
      when(certificatesHandleBloc.stream)
          .thenAnswer((_) => const Stream.empty());

      when(addCertificateBloc.state).thenAnswer(
        (_) => const AddCertificateState(
          screenStatus: ScreenStatus.initial(),
        ),
      );

      when(certificatesHandleBloc.state).thenAnswer(
        (_) => CertificatesHandleState(
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.initial(),
          certificateCheck: const CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 2,
        ),
      );

      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertificatesWarningScreenAndroid(),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<AddCertificateBloc>.value(value: addCertificateBloc),
          BlocProvider<CertificatesHandleBloc>.value(
            value: certificatesHandleBloc,
          ),
        ],
      );

      expect(
        find.text(myContext
            .localizations.certificate_error_problems_with_certificates_title),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations
            .certificate_error_problems_with_certificates_subtitle),
        findsOneWidget,
      );
    },
  );
}
