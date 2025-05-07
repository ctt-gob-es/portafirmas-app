import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/presentation/features/server/change_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/select_change_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_screen.dart';

import '../../instruments/pump_app.dart';

import 'select_change_server_test.mocks.dart';

@GenerateMocks([SelectServerBloc])
void main() async {
  late MockSelectServerBloc serverBloc;

  setUpAll(() {
    serverBloc = MockSelectServerBloc();
  });

  testWidgets(
    'GIVEN select select server screen WHEN is select server THEN render correct',
    (widgetTester) async {
      when(serverBloc.stream)
          .thenAnswer((realInvocation) => Stream.fromIterable([]));
      when(serverBloc.state)
          .thenAnswer((realInvocation) => SelectServerState.initial());

      await widgetTester.pumpApp(
        const SelectChangeServerScreen.firstTime(),
        providers: [BlocProvider<SelectServerBloc>.value(value: serverBloc)],
      );

      expect(
        find.byType(SelectServerFirstTimeScreen),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GIVEN select change server screen WHEN is select server THEN render correct',
    (widgetTester) async {
      when(serverBloc.stream)
          .thenAnswer((realInvocation) => Stream.fromIterable([]));
      when(serverBloc.state)
          .thenAnswer((realInvocation) => SelectServerState.initial());

      await widgetTester.pumpApp(
        const SelectChangeServerScreen.change(),
        providers: [BlocProvider<SelectServerBloc>.value(value: serverBloc)],
      );

      expect(
        find.byType(ChangeServerScreen),
        findsOneWidget,
      );
    },
  );
}
