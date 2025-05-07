import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

import '../instruments/pump_app.dart';

void main() {
  testWidgets('GIVEN THEN WHEN', (tester) async {
    await tester.pumpApp(
      ScreenWithLoader(loading: true, child: Container()),
    );
    expect(find.byType(LoadingComponent), findsOneWidget);
  });
}
