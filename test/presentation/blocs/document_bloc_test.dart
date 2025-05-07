import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import '../instruments/requests_instruments.dart';
import 'document_bloc_test.mocks.dart';

@GenerateMocks([RequestRepositoryContract])
void main() {
  late DocumentBloc documentBloc;
  late MockRequestRepositoryContract requestRepositoryContract;

  setUp(() {
    requestRepositoryContract = MockRequestRepositoryContract();
    documentBloc = DocumentBloc(repositoryContract: requestRepositoryContract);
  });

  group('document bloc test', () {
    blocTest(
      'GIVEN document bloc, WHEN getDocument event is called, THEN document will be downloaded and shown',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        )).thenAnswer((_) async {
          return const Result.success('');
        });

        bloc.add(DocumentEvent.getDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        ));
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: givenDocumentEntity().docId,
          docType: DocumentType.doc,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.success(),
          docId: givenDocumentEntity().docId,
          filePath: '',
          docType: DocumentType.doc,
        ),
        DocumentState.initial(),
      ],
    );

    blocTest(
      'GIVEN document bloc, WHEN getDocument event is called and there is an error THEN error state will be emitted',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.authExpired());
        });

        bloc.add(DocumentEvent.getDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        ));
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: givenDocumentEntity().docId,
          docType: DocumentType.doc,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.error(),
        ),
      ],
    );

    blocTest(
      'GIVEN document bloc, WHEN getSignedDocument event is called, THEN document will be downloaded and shown',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getSignedDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
          signFormat: givenDocumentEntity().signFrmt,
        )).thenAnswer((_) async {
          return const Result.success('');
        });

        bloc.add(
          DocumentEvent.getSignedDocument(
            docId: givenDocumentEntity().docId,
            docName: givenDocumentEntity().docName,
            signFormat: givenDocumentEntity().signFrmt,
          ),
        );
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: '${givenDocumentEntity().docId}${SignReport.signSuffix}',
          docType: DocumentType.signDoc,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.success(),
          docId: '${givenDocumentEntity().docId}${SignReport.signSuffix}',
          docType: DocumentType.signDoc,
          filePath: '',
        ),
        DocumentState.initial(),
      ],
    );

    blocTest(
      'GIVEN document bloc, WHEN getSignedDocument event is called and there is an error THEN error state will be emitted',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getSignedDocument(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
          signFormat: givenDocumentEntity().signFrmt,
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.authExpired());
        });

        bloc.add(
          DocumentEvent.getSignedDocument(
            docId: givenDocumentEntity().docId,
            docName: givenDocumentEntity().docName,
            signFormat: givenDocumentEntity().signFrmt,
          ),
        );
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: '${givenDocumentEntity().docId}${SignReport.signSuffix}',
          docType: DocumentType.signDoc,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.error(),
        ),
      ],
    );

    blocTest(
      'GIVEN document bloc, WHEN getSignReport event is called, THEN document will be downloaded and shown',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getSignReport(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        )).thenAnswer((_) async {
          return const Result.success('');
        });

        bloc.add(
          DocumentEvent.getSignReport(
            docId: givenDocumentEntity().docId,
            docName: givenDocumentEntity().docName,
          ),
        );
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: '${givenDocumentEntity().docId}${SignDocument.reportSuffix}',
          docType: DocumentType.signReport,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.success(),
          docId: '${givenDocumentEntity().docId}${SignDocument.reportSuffix}',
          docType: DocumentType.signReport,
          filePath: '',
        ),
        DocumentState.initial(),
      ],
    );

    blocTest(
      'GIVEN document bloc, WHEN getSignReport event is called and there is an error THEN error state will be emitted',
      build: () => documentBloc,
      act: (DocumentBloc bloc) {
        when(requestRepositoryContract.getSignReport(
          docId: givenDocumentEntity().docId,
          docName: givenDocumentEntity().docName,
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.authExpired());
        });

        bloc.add(
          DocumentEvent.getSignReport(
            docId: givenDocumentEntity().docId,
            docName: givenDocumentEntity().docName,
          ),
        );
      },
      expect: () => [
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.loading(),
          docId: '${givenDocumentEntity().docId}${SignDocument.reportSuffix}',
          docType: DocumentType.signReport,
        ),
        DocumentState.initial().copyWith(
          downloadStatus: const ScreenStatus.error(),
        ),
      ],
    );
  });
}
