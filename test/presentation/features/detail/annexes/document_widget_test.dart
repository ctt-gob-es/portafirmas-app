import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/document_widget.dart';

import '../../../instruments/pump_app.dart';
import '../../../instruments/requests_instruments.dart';
import 'document_widget_test.mocks.dart';

@GenerateMocks([DocumentBloc])
void main() {
  late MockDocumentBloc docbloc;
  late DocumentWidget documentWidget;

  setUp(() {
    docbloc = MockDocumentBloc();
    documentWidget = DocumentWidget(
      doc: givenDocumentEntity(),
      documentType: DocumentType.doc,
    );
  });

  group('Document widget tests', () {
    testWidgets(
      'GIVEN a document widget WHEN bloc is downloading the doc THEN a loader will be shown',
      (widgetTester) async {
        when(docbloc.stream).thenAnswer((_) => const Stream.empty());
        when(docbloc.state).thenAnswer(
          (_) => const DocumentState(
            downloadStatus: ScreenStatus.loading(),
            docId: 'docId',
            filePath: null,
            docType: DocumentType.doc,
          ),
        );

        await widgetTester.pumpApp(
          documentWidget,
          providers: [BlocProvider<DocumentBloc>.value(value: docbloc)],
        );

        var loader = find.byType(CircularProgressIndicator);
        expect(loader, findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN a document widget WHEN initial state THEN document name will be shown',
      (widgetTester) async {
        when(docbloc.stream).thenAnswer((_) => const Stream.empty());
        when(docbloc.state).thenAnswer(
          (_) => DocumentState.initial(),
        );

        await widgetTester.pumpApp(
          documentWidget,
          providers: [BlocProvider<DocumentBloc>.value(value: docbloc)],
        );

        var doc = find.text(givenDocumentEntity().docName);

        await widgetTester.tap(doc);
        await widgetTester.pumpAndSettle();

        expect(doc, findsOneWidget);
      },
    );
  });
}
