import 'package:flutter_test/flutter_test.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  group('Expanded button test', () {
    testWidgets(
      'GIVEN a Expanded button secondary WHEN I press it THEN I will get nothing',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: WidgetsInstruments.getExpandedButton(true),
          ),
        );

        var button1 = find.text(WidgetsInstruments.mainButtonText);

        expect(button1, findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN a Expanded button tertiary WHEN I press it THEN I will get nothing',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: WidgetsInstruments.getExpandedButton(false),
          ),
        );

        var button1 = find.text(WidgetsInstruments.mainButtonText);

        expect(button1, findsOneWidget);
      },
    );
  });
}
