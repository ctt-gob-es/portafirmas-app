import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/document_remote_entity.dart';

void main() {
  group('DocumentRemoteEntityExtension', () {
    test(
      'toDocumentEntity correctly converts DocumentRemoteEntity to DocumentEntity',
      () {
        const documentRemoteEntity = DocumentRemoteEntity(
          docId: '12345',
          docName: 'Sample Document',
          docSize: '10MB',
          signFrmt: 'CAdES',
          signAlgo: 'SHA256',
          params: 'some params',
        );

        final documentEntity = documentRemoteEntity.toDocumentEntity();

        expect(documentEntity.docId, '12345');
        expect(documentEntity.docName, 'Sample Document');
        expect(documentEntity.docSize, '10MB');
        expect(documentEntity.signFrmt, 'CAdES');
        expect(documentEntity.signAlgo, 'SHA256');
        expect(documentEntity.params, 'some params');
      },
    );
  });
}
