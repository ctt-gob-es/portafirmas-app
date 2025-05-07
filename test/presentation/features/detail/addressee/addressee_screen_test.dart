import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/detail/addressee/addressee_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';

import 'package:portafirmas_app/presentation/features/detail/widget/sign_addressee.dart';

import '../../../../instruments/localization_injector.dart';
import '../../../../instruments/widgets_instruments.dart';
import 'addressee_screen_test.mocks.dart';

@GenerateMocks([DetailRequestBloc])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDetailRequestBloc bloc;
  setUp(() {
    bloc = MockDetailRequestBloc();
  });

  testWidgets(
    'GIVEN the value of signLinesType WHEN show the AddresseeScreen THEN show the content of fall version',
    (tester) async {
      when(bloc.state).thenReturn(DetailRequestState(
        screenStatus: const ScreenStatus.success(),
        loadContent:
            WidgetsInstruments.detailRequestResponse(WidgetsInstruments.fall),
        isFooterActive: true,
      ));
      when(bloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        BlocProvider<DetailRequestBloc>.value(
          value: bloc,
          child: const LocalizationsInj(
            child: AddresseeScreen(),
          ),
        ),
      );

      expect(find.text(WidgetsInstruments.inputText), findsOneWidget);
      expect(find.byType(AFStepsInfo), findsOneWidget);
    },
  );

  testWidgets(
    'GIVEN the value of signLinesType WHEN show the AddresseeScreen THEN show the content of parallel version',
    (tester) async {
      when(bloc.state).thenReturn(DetailRequestState(
        screenStatus: const ScreenStatus.success(),
        loadContent: WidgetsInstruments.detailRequestResponse(
          WidgetsInstruments.parallel,
        ),
        isFooterActive: true,
      ));
      when(bloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        BlocProvider<DetailRequestBloc>.value(
          value: bloc,
          child: const LocalizationsInj(
            child: AddresseeScreen(),
          ),
        ),
      );

      expect(find.text(WidgetsInstruments.inputText), findsOneWidget);
      expect(find.byType(SignAddressee), findsWidgets);
    },
  );
}
