import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/extensions/reject_status_extensions.dart';
import 'package:portafirmas_app/domain/models/reject_status.dart';

void main() {
  group('RejectStatusEnumExtension', () {
    Widget createTestableWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', ''),
          Locale('gl', ''),
          Locale('eu', ''),
          Locale('en', ''),
          Locale('ca', ''),
        ],
        home: child,
        navigatorKey: GlobalKey<NavigatorState>(),
        theme: AFTheme.getTheme(),
      );
    }

    testWidgets(
      'toLocalizedString returns correct string for rejected status',
      (WidgetTester tester) async {
        late BuildContext context;
        await tester.pumpWidget(
          createTestableWidget(
            Builder(
              builder: (BuildContext cnt) {
                context = cnt;

                return const SizedBox();
              },
            ),
          ),
        );
        final result = RejectStatus.rejected.toLocalizedString(context);
        expect(result, 'Rejected');
      },
    );

    testWidgets(
      'toLocalizedString returns correct string for cancelled status',
      (WidgetTester tester) async {
        late BuildContext context;
        await tester.pumpWidget(createTestableWidget(
          Builder(
            builder: (BuildContext cnt) {
              context = cnt;

              return const SizedBox();
            },
          ),
        ));
        final result = RejectStatus.cancelled.toLocalizedString(context);

        expect(result, 'Cancelled');
      },
    );

    testWidgets(
      'toLocalizedString returns correct string for revoked status',
      (WidgetTester tester) async {
        late BuildContext context;
        await tester.pumpWidget(createTestableWidget(
          Builder(
            builder: (BuildContext cnt) {
              context = cnt;

              return const SizedBox();
            },
          ),
        ));
        final result = RejectStatus.revoked.toLocalizedString(context);

        expect(result, 'Revoked');
      },
    );

    testWidgets(
      'toLocalizedString returns empty string for null status',
      (WidgetTester tester) async {
        late BuildContext context;
        await tester.pumpWidget(createTestableWidget(
          Builder(
            builder: (BuildContext cnt) {
              context = cnt;

              return const SizedBox();
            },
          ),
        ));
        final result = (null).toLocalizedString(context);

        expect(
          result,
          '',
        );
      },
    );
  });
}
