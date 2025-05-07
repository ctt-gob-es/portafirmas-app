import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/certificates/widgets/certificate_card.dart';

import '../../../data/instruments/certificate_instruments.dart';
import '../../instruments/pump_app.dart';

void main() {
  testWidgets(
    'GIVEN cert card WHEN show THEN show correct info',
    (widgetTester) async {
      late BuildContext myContext;

      await widgetTester.pumpApp(
        CertificateCard(certificate: givenCertificateEntity()),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations
            .cert_card_emitter(givenCertificateEntity().emitterName)),
        findsOneWidget,
      );

      expect(
        find.text(givenCertificateEntity().holderName),
        findsOneWidget,
      );
    },
  );
}
