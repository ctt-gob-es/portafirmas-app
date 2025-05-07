import 'package:flutter_test/flutter_test.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  testWidgets(
    'GIVEN a ProfileModelHelper WHEN I tap the section THEN will do an action',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        LocalizationsInj(
          child: WidgetsInstruments.getProfileTemplateSection(),
        ),
      );

      var profileModelHelperText = find.text(WidgetsInstruments.inputText);

      await widgetTester.ensureVisible(profileModelHelperText);
      await widgetTester.tap(profileModelHelperText);

      expect(profileModelHelperText, findsOneWidget);
    },
  );
}
