import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/widget/login_error_overlay.dart';

import '../instruments/pump_app.dart';

void main() {
  group('LoginErrorOverlay', () {
    testWidgets(
      'shows modal with correct error details for invalid certificate',
      (WidgetTester tester) async {
        const error = RepositoryError.invalidCertificate();
        late BuildContext myContext;

        await tester.pumpApp(
          const Scaffold(
            body: LoginErrorOverlay(error: error),
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(find.byType(LoginErrorOverlay), findsOneWidget);
        expect(
          find.text(myContext.localizations.cert_not_valid),
          findsOneWidget,
        );
        expect(
          find.text(myContext.localizations.cert_not_valid_description),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows modal with correct error details for expired certificate',
      (WidgetTester tester) async {
        const error = RepositoryError.expiredCertificate();
        late BuildContext myContext;

        await tester.pumpApp(
          const Scaffold(
            body: LoginErrorOverlay(error: error),
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(find.byType(LoginErrorOverlay), findsOneWidget);
        expect(
          find.text(myContext.localizations.cert_not_valid_expired),
          findsOneWidget,
        );
        expect(
          find.text(myContext.localizations.cert_not_valid_description_expired),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows modal with correct error details for revoked certificate',
      (WidgetTester tester) async {
        const error = RepositoryError.revokedCertificate();
        late BuildContext myContext;

        await tester.pumpApp(
          const Scaffold(
            body: LoginErrorOverlay(error: error),
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(find.byType(LoginErrorOverlay), findsOneWidget);
        expect(
          find.text(myContext.localizations.cert_not_valid_revoked),
          findsOneWidget,
        );
        expect(
          find.text(myContext.localizations.cert_not_valid_description_revoked),
          findsOneWidget,
        );
      },
    );
  });
}
