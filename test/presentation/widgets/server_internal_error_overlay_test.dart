import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/server_internal_error_overlay.dart';

import '../instruments/pump_app.dart';

void main() {
  late BuildContext myContext;

  testWidgets(
    'GIVEN a modal ServerInternalError THEN find the contents and button WHEN interact with it',
    (tester) async {
      await tester.pumpApp(
        const ServerInternalErrorOverlay(),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.something_went_wrong_modal_title),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.server_internal_error_description),
        findsOneWidget,
      );
      await tester.tap(find.text(myContext.localizations.general_understood));
      await tester.pumpAndSettle();
      expect(find.byType(Navigator), findsOneWidget);
    },
  );
}
