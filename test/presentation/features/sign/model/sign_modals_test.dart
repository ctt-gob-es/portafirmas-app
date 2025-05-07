import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_modals.dart';

import '../../../instruments/pump_app.dart';
import 'sign_modals_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MultiSelectionRequestBloc>(),
  MockSpec<RequestsBloc>(),
  MockSpec<DetailRequestBloc>(),
])
void main() {
  late MockDetailRequestBloc mockDetailRequestBloc;
  late MockMultiSelectionRequestBloc mockMultiSelectionRequestBloc;
  late MockRequestsBloc mockRequestsBloc;

  setUp(() {
    mockDetailRequestBloc = MockDetailRequestBloc();
    mockMultiSelectionRequestBloc = MockMultiSelectionRequestBloc();
    mockRequestsBloc = MockRequestsBloc();
  });

  testWidgets(
    'render showModalEndValidate when isSingleRequest is true ',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        Scaffold(
          body: ElevatedButton(
            onPressed: () {
              SignModals.showModalEndValidate(
                tester.element(find.byType(ElevatedButton)),
                true,
                1,
                true,
              );
            },
            child: const Text('Show Modal'),
          ),
        ),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<DetailRequestBloc>.value(value: mockDetailRequestBloc),
        ],
      );

      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      expect(
        find.text(myContext.localizations.validate_module_title_final_step),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.validate_module_subtitle_final_step),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.general_understood),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'render showModalEndValidate when isSingleRequest is false ',
    (WidgetTester tester) async {
      late BuildContext myContext;

      await tester.pumpApp(
        Scaffold(
          body: ElevatedButton(
            onPressed: () {
              SignModals.showModalEndValidate(
                tester.element(find.byType(ElevatedButton)),
                false,
                1,
                false,
              );
            },
            child: const Text('Show Modal'),
          ),
        ),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<MultiSelectionRequestBloc>.value(
            value: mockMultiSelectionRequestBloc,
          ),
          BlocProvider<RequestsBloc>.value(
            value: mockRequestsBloc,
          ),
        ],
      );

      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          myContext.localizations.validate_multiple_module_title_final_step,
        ),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations
            .validate_multiple_module_subtitle_final_step(1)),
        findsOneWidget,
      );
      expect(
        find.text(myContext.localizations.general_understood),
        findsOneWidget,
      );
    },
  );
}
