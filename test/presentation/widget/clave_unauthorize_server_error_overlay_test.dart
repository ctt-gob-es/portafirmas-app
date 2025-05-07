import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/presentation/widget/clave_unauthorize_server_error_overlay.dart';

import '../instruments/pump_app.dart';

void main() {
  testWidgets(
    'ClaveUnauthorizeServerErrorOverlay displays correct title and description for unauthorized error',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        const Scaffold(
          body: ClaveUnauthorizeServerErrorOverlay(
            claveErrorType: ClaveErrorType.unauthorized,
          ),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.error_login_cert_title),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations.clave_sign_in_unknown_user_description,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'ClaveUnauthorizeServerErrorOverlay displays correct title and description for expired error',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        const Scaffold(
          body: ClaveUnauthorizeServerErrorOverlay(
            claveErrorType: ClaveErrorType.expired,
          ),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.clave_not_valid_expired),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.clave_sign_in_expired_description),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'ClaveUnauthorizeServerErrorOverlay displays correct title and description for revoked error',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        const Scaffold(
          body: ClaveUnauthorizeServerErrorOverlay(
            claveErrorType: ClaveErrorType.revoked,
          ),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.clave_not_valid_revoked),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.clave_sign_in_revoked_description),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'ClaveUnauthorizeServerErrorOverlay displays correct title and description for unknown error',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        const Scaffold(
          body: ClaveUnauthorizeServerErrorOverlay(
            claveErrorType: ClaveErrorType.unknown,
          ),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.something_went_wrong_modal_title),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations.clave_sign_in_generic_error_description,
        ),
        findsOneWidget,
      );
    },
  );
}
