import 'package:app_factory_ui/forms/af_input/af_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/presentation/features/server/add_modify_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/delete_overlay_success.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';

import '../../../data/instruments/servers_instruments.dart';
import '../../instruments/pump_app.dart';
import 'add_modify_server_test.mocks.dart';

@GenerateMocks([SelectServerBloc, GoRouter])
void main() async {
  late MockSelectServerBloc serverBloc;
  late MockGoRouter router;

  setUp(() {
    serverBloc = MockSelectServerBloc();
    router = MockGoRouter();
  });

  testWidgets(
    'GIVEN add modify screen WHEN not have initial server THEN render correct',
    (widgetTester) async {
      when(serverBloc.stream)
          .thenAnswer((realInvocation) => Stream.fromIterable([]));
      when(serverBloc.state)
          .thenAnswer((realInvocation) => SelectServerState.initial());

      late final BuildContext myContext;
      await widgetTester.pumpApp(
        const AddModifyServerScreen(),
        providers: [BlocProvider<SelectServerBloc>.value(value: serverBloc)],
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.add_server_sub),
        findsOneWidget,
      );

      expect(
        find.text(myContext.localizations.add_server_title),
        findsOneWidget,
      );

      expect(
        find.text(myContext.localizations.edit_server_delete),
        findsNothing,
      );
    },
  );

  testWidgets(
    'GIVEN add modify screen WHEN have initial server THEN render correct',
    (widgetTester) async {
      when(serverBloc.stream)
          .thenAnswer((realInvocation) => Stream.fromIterable([]));
      when(serverBloc.state)
          .thenAnswer((realInvocation) => SelectServerState.initial());

      late final BuildContext myContext;
      await widgetTester.pumpApp(
        AddModifyServerScreen(
          initialServer: givenServerEntity(),
        ),
        providers: [BlocProvider<SelectServerBloc>.value(value: serverBloc)],
        onGetContext: (context) => myContext = context,
      );

      expect(
        find.text(myContext.localizations.edit_server_title),
        findsOneWidget,
      );

      expect(
        find.text(givenServerEntity().alias),
        findsNWidgets(2),
      );

      expect(
        find.text(myContext.localizations.edit_server_delete),
        findsOneWidget,
      );
    },
  );

  testWidgets(' tap _onTapAddButton method to Add New Server', (tester) async {
    late final BuildContext myContext;
    when(serverBloc.stream)
        .thenAnswer((realInvocation) => Stream.fromIterable([]));
    when(serverBloc.state)
        .thenAnswer((realInvocation) => SelectServerState.initial());
    when(serverBloc.add(any)).thenAnswer((_) {
      return;
    });

    await tester.pumpApp(
      const AddModifyServerScreen(),
      providers: [
        BlocProvider<SelectServerBloc>.value(value: serverBloc),
      ],
      onGetContext: (appContext) => myContext = appContext,
    );
    final inputs = find.byType(AFTextInput);

    await tester.enterText(inputs.first, 'alias');
    await tester.enterText(
      inputs.last,
      'https://pre-portafirmas.redsara.es/pfmovil/pf',
    );
    await tester.pumpAndSettle();
    final button = find.text(myContext.localizations.add_server_save_btn);
    await tester.tap(button);
    await tester.pumpAndSettle();

    verify(serverBloc.add(any));
  });

  testWidgets(
    ' tap _onTapAddButton method to try to Add Server',
    (tester) async {
      late final BuildContext myContext;
      when(serverBloc.stream)
          .thenAnswer((realInvocation) => Stream.fromIterable([]));
      when(serverBloc.state)
          .thenAnswer((realInvocation) => SelectServerState.initial());
      when(serverBloc.add(any)).thenAnswer((_) {
        return;
      });
      when(router.pop(any)).thenAnswer((_) {
        return;
      });

      await tester.pumpApp(
        AddModifyServerScreen(
          initialServer: ServerEntity(
            databaseIndex: 1000,
            alias: 'alias',
            url: 'https://pre-portafirmas.redsara.es/pfmovil/pf',
          ),
        ),
        providers: [
          BlocProvider<SelectServerBloc>.value(value: serverBloc),
        ],
        onGetContext: (appContext) => myContext = appContext,
        router: router,
      );

      final button = find.text(myContext.localizations.add_server_save_btn);
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(serverBloc.add(any));
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('is _showDeleteModal render correctly', (tester) async {
    when(serverBloc.stream)
        .thenAnswer((realInvocation) => Stream.fromIterable([]));
    when(serverBloc.state)
        .thenAnswer((realInvocation) => SelectServerState.initial());
    when(serverBloc.add(any)).thenAnswer((_) {
      return;
    });
    when(router.pop(any)).thenAnswer((_) {
      return;
    });

    await tester.pumpApp(
      AddModifyServerScreen(
        initialServer: ServerEntity(
          databaseIndex: 1000,
          alias: 'alias',
          url: 'https://pre-portafirmas.redsara.es/pfmovil/pf',
        ),
      ),
      providers: [
        BlocProvider<SelectServerBloc>.value(value: serverBloc),
      ],
      router: router,
    );

    await tester.tap(find.byType(ClearButton));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteOverlaySuccess), findsOneWidget);

    await tester.tap(find.byType(DeleteOverlaySuccess).first);
    await tester.pumpAndSettle();
  });
}
