import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/localizations_extensions.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/add_overlay_error.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/add_overlay_success.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/server_card.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

import '../../../data/instruments/servers_instruments.dart';
import '../../instruments/pump_app.dart';

void main() {
  testWidgets(
    'GIVEN a overlay error WHEN show THEN appear server name',
    (widgetTester) async {
      late final BuildContext myContext;
      await widgetTester.pumpApp(
        AddOverlayError(
          serverName: 'serverName',
          onRetryTap: () => DoNothingAction(),
        ),
        onGetContext: (context) => myContext = context,
      );
      expect(find.byType(ModalTemplate), findsOneWidget);
      expect(
        find.text(myContext.localizations.add_server_modal_error_title),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations.add_server_modal_error_sub('serverName'),
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'GIVEN a overlay success WHEN show THEN appear server name',
    (widgetTester) async {
      late final BuildContext myContext;
      await widgetTester.pumpApp(
        const AddOverlaySuccess(
          serverName: 'serverName',
        ),
        onGetContext: (context) => myContext = context,
      );
      expect(find.byType(ModalTemplate), findsOneWidget);
      expect(
        find.text(myContext.localizations.add_server_modal_success_title),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations.add_server_modal_success_sub('serverName'),
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'GIVEN a server card with default server WHEN show THEN render correctly',
    (widgetTester) async {
      late final BuildContext myContext;
      await widgetTester.pumpApp(
        ServerCard(
          server: givenServerEntityDefault(),
          isSelected: false,
          onTap: () => DoNothingAction(),
        ),
        onGetContext: (context) => myContext = context,
      );
      expect(
        find.text(
          myContext.localizations.defaultServerName(givenServerEntityDefault()),
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          myContext.localizations
              .defaultServerSubtitle(givenServerEntityDefault()),
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'GIVEN a server card with non default server WHEN show THEN render correctly',
    (widgetTester) async {
      await widgetTester.pumpApp(
        ServerCard(
          server: givenServerEntity(),
          isSelected: false,
          onTap: () => DoNothingAction(),
        ),
      );
      expect(
        find.text(
          givenServerEntity().alias,
        ),
        findsOneWidget,
      );
    },
  );
}
