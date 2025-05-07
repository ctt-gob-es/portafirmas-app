import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/annexe_widget.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/annexes_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import '../../../../instruments/localization_injector.dart';

import '../../../instruments/requests_instruments.dart';
import 'annexes_screen_test.mocks.dart';

@GenerateMocks([DetailRequestBloc, DocumentBloc])
void main() {
  late MockDetailRequestBloc detailRequestBloc;
  late MockDocumentBloc documentBloc;
  late BuildContext myContext;

  setUp(() {
    detailRequestBloc = MockDetailRequestBloc();
    documentBloc = MockDocumentBloc();
  });
  testWidgets(
    'GIVEN a Annexee screen WHEN requests has annexes THEN show the content',
    (tester) async {
      when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
      when(documentBloc.stream).thenAnswer((_) => const Stream.empty());
      when(documentBloc.state).thenAnswer(
        (_) => DocumentState.initial(),
      );
      when(detailRequestBloc.state).thenAnswer(
        (_) => DetailRequestState.initial()
            .copyWith(loadContent: givenDetailRequestEntity),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<DetailRequestBloc>.value(
              value: detailRequestBloc,
            ),
            BlocProvider<DocumentBloc>.value(
              value: documentBloc,
            ),
          ],
          child: LocalizationsInj(
            child: Builder(builder: (context) {
              myContext = context;

              return const AnnexesScreen(
                requestStatus: RequestStatus.pending,
              );
            }),
          ),
        ),
      );
      expect(
        find.text(myContext.localizations.generic_annexes),
        findsOneWidget,
      );

      expect(find.byType(AnnexeWidget), findsWidgets);
    },
  );
}
