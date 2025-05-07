import 'package:flutter_test/flutter_test.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  group('Modal template test', () {
    testWidgets(
      'GIVEN a Overlay with ModalTemplate WHEN I press the button THEN it will pop',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          LocalizationsInj(
            child: WidgetsInstruments.getModalTemplate(),
          ),
        );

        var button = find.text(WidgetsInstruments.mainButtonText);
        var button2 = find.text(WidgetsInstruments.secondaryButtonText);

        //tap main button
        await widgetTester.ensureVisible(button);
        await widgetTester.tap(button);

        await widgetTester.pumpAndSettle();

        //tap secondary button
        await widgetTester.ensureVisible(button2);
        await widgetTester.tap(button2);

        expect(button, findsOneWidget);
      },
    );
  });
}
