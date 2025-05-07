import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_push_notification.dart';

import '../../instruments/localization_injector.dart';
import '../../instruments/widgets_instruments.dart';

void main() {
  testWidgets(
    'Switch toggle test',
    (widgetTester) async {
      bool value = true;

      await widgetTester.pumpWidget(LocalizationsInj(
        child: WidgetsInstruments.getPushWidget(
          value,
          (newValue) {
            value = newValue;
          },
        ),
      ));

      await widgetTester.tap(find.byType(ProfileTemplatePushNotifications));
      expect(value, isTrue);
    },
  );
}
