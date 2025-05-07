import 'package:flutter_test/flutter_test.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  group('Clear button test', () {
    testWidgets(
      'GIVEN a Clear button WHEN I press it THEN I will get nothing',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: WidgetsInstruments.getClearButton(),
          ),
        );

        var button1 = find.text(WidgetsInstruments.mainButtonText);

        expect(button1, findsOneWidget);
      },
    );
  });
}
