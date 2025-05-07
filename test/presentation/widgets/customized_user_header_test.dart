import 'package:flutter_test/flutter_test.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  testWidgets(
    'GIVEN a Customized user header WHEN it loads the section THEN render correctly',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        LocalizationsInj(
          child: WidgetsInstruments.getAFheaderProcess(),
        ),
      );

      var userHeader = find.text(WidgetsInstruments.certificate);

      await widgetTester.ensureVisible(userHeader);
      await widgetTester.tap(userHeader);

      expect(userHeader, findsOneWidget);
    },
  );
}
