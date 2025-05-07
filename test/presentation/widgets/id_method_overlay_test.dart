import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/id_method_overlay.dart';

import '../instruments/pump_app.dart';

void main() {
  late BuildContext myContext;
  testWidgets(
    'GIVEN a IdMethodOverlay THEN show me the correct content WHEN isClaveRegister is true',
    (tester) async {
      await tester.pumpApp(
        IdMethodOverlay(
          isClaveRegister: true,
          onTapHelp: () => DoNothingAction(),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.choose_id_register),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.choose_id_overlay_in_person),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GIVEN a IdMethodOverlay THEN show me the correct content WHEN isClaveRegister is false',
    (tester) async {
      await tester.pumpApp(
        IdMethodOverlay(
          isClaveRegister: false,
          onTapHelp: () => DoNothingAction(),
        ),
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.choose_id_overlay_clave_sub),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.general_call_060),
        findsOneWidget,
      );
    },
  );
}
