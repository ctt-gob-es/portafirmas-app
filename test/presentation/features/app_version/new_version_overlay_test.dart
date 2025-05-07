import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/features/app_version/widgets/new_version_overlay.dart';

import '../../../instruments/localization_injector.dart';
import '../../instruments/pump_app.dart';

void main() {
  group('New version overlay test', () {
    testWidgets(
      'GIVEN a NewVersionOverlay WHEN get the modal THEN the new version subtitle will be shown',
      (widgetTester) async {
        await widgetTester.pumpApp(
          LocalizationsInj(
            child: NewVersionOverlay(
              iconPath: Assets.iconCircleInfo,
              onTapButton: () => DoNothingAction(),
            ),
          ),
        );

        var subtitle = find.byType(
          NewVersionOverlay,
        );
        expect(subtitle, findsOneWidget);
      },
    );
  });
}
