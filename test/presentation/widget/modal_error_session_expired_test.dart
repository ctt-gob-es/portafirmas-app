import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

import '../instruments/pump_app.dart';

void main() {
  testWidgets(
    'modalSessionExpired shows the session expired modal',
    (tester) async {
      late BuildContext myContext;
      await tester.pumpApp(
        Scaffold(
          body: ElevatedButton(
            onPressed: () =>
                ModalErrorSessionExpired.modalSessionExpired(myContext),
            child: const Text('Show Modal'),
          ),
        ),
        onGetContext: (context) => myContext = context,
      );

      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(ModalTemplate), findsOneWidget);
      expect(
        find.text(myContext.localizations.expired_session_modal_header),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.expired_session_modal_description),
        findsOneWidget,
      );
    },
  );
}
