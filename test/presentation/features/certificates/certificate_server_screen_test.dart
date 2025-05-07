import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificate_server_screen.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificate_status_check.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/widgets/certificate_card.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/server_card.dart';

import '../../../data/instruments/certificate_instruments.dart';
import '../../../data/instruments/servers_instruments.dart';
import '../../instruments/pump_app.dart';

import 'certificate_server_screen_test.mocks.dart';

@GenerateMocks([
  AuthBloc,
  SelectServerBloc,
  CertificatesHandleBloc,
])
void main() {
  late MockAuthBloc authBloc;
  late MockSelectServerBloc selectServerBloc;
  late MockCertificatesHandleBloc certificatesHandleBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    selectServerBloc = MockSelectServerBloc();
    certificatesHandleBloc = MockCertificatesHandleBloc();
  });

  testWidgets(
    'GIVEN certificate server screen WHEN no certificate selected THEN not show certificate',
    (widgetTester) async {
      when(authBloc.stream).thenAnswer((_) => const Stream.empty());
      when(selectServerBloc.stream).thenAnswer((_) => const Stream.empty());
      when(certificatesHandleBloc.stream)
          .thenAnswer((_) => const Stream.empty());

      when(authBloc.state).thenAnswer(
        (_) => AuthState.initial(),
      );
      when(selectServerBloc.state).thenAnswer(
        (_) => SelectServerState(
          preSelectedServer: givenServerEntity(),
          selectedServerFinal: givenServerEntity(),
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.success(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: givenServerEntityList(),
        ),
      );
      when(certificatesHandleBloc.state).thenAnswer(
        (_) => CertificatesHandleState.initial(),
      );

      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertificateAndServerSelectedScreen(),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<SelectServerBloc>.value(value: selectServerBloc),
          BlocProvider<CertificatesHandleBloc>.value(
            value: certificatesHandleBloc,
          ),
        ],
      );

      expect(
        find.text(givenServerEntity().alias),
        findsOneWidget,
      );

      expect(
        find.text(myContext.localizations.default_certificate_explain),
        findsOneWidget,
      );

      expect(
        find.byType(ServerCard),
        findsOneWidget,
      );

      expect(
        find.byType(CertificateCard),
        findsNothing,
      );
    },
  );

  testWidgets(
    'GIVEN certificate server screen WHEN certificate selected THEN not show certificate',
    (widgetTester) async {
      when(authBloc.stream).thenAnswer((_) => const Stream.empty());
      when(selectServerBloc.stream).thenAnswer((_) => const Stream.empty());
      when(certificatesHandleBloc.stream)
          .thenAnswer((_) => const Stream.empty());

      when(authBloc.state).thenAnswer(
        (_) => AuthState.initial(),
      );
      when(selectServerBloc.state).thenAnswer(
        (_) => SelectServerState(
          preSelectedServer: givenServerEntity(),
          selectedServerFinal: givenServerEntity(),
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.success(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: givenServerEntityList(),
        ),
      );
      when(certificatesHandleBloc.state).thenAnswer(
        (_) => CertificatesHandleState(
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.success(),
          certificateCheck: const CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 0,
        ),
      );

      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertificateAndServerSelectedScreen(),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<SelectServerBloc>.value(value: selectServerBloc),
          BlocProvider<CertificatesHandleBloc>.value(
            value: certificatesHandleBloc,
          ),
        ],
      );

      expect(
        find.text(givenServerEntity().alias),
        findsOneWidget,
      );
      expect(
        find.text(givenCertificateEntity().holderName),
        findsOneWidget,
      );

      expect(
        find.text(myContext.localizations.default_certificate_explain),
        findsOneWidget,
      );

      expect(
        find.byType(ServerCard),
        findsOneWidget,
      );

      expect(
        find.byType(CertificateCard),
        findsOneWidget,
      );
    },
  );
}
