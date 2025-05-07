import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/cert_added_error_screen.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/cert_added_success_screen.dart';

import '../../instruments/pump_app.dart';

void main() {
  testWidgets(
    'GIVEN cert added success screen WHEN show THEN show correct info',
    (widgetTester) async {
      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertAddedSuccessScreen(),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.cert_added_title),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.cert_added_subtitle),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'GIVEN cert added error screen WHEN show THEN show correct info',
    (widgetTester) async {
      late BuildContext myContext;

      await widgetTester.pumpApp(
        const CertAddedErrorScreen(),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.cert_error_adding_title),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.cert_error_adding_subtitle),
        findsOneWidget,
      );
    },
  );
}
