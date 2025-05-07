
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/utils/document_utils.dart';
import 'package:portafirmas_app/app/utils/error_utils.dart';
import 'package:portafirmas_app/domain/models/document_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/customized_content_document_widget.dart';

class DocumentWidget extends StatelessWidget {
  final DocumentEntity doc;
  final DocumentType documentType;

  const DocumentWidget({
    super.key,
    required this.doc,
    required this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          state.downloadStatus.whenOrNull(
            success: () async {
              if (state.filePath != null &&
                  state.isDocDownloaded(doc.docId, documentType)) {
                await OpenFilex.open(state.filePath ?? '');
              }
            },
            error: (_) => ErrorUtils.showErrorOverlay(context),
          );
        },
        builder: (context, state) => state.isLoadingDoc(
          doc.docId,
          documentType,
        )
            ? const Center(
                heightFactor: 2,
                child: CircularProgressIndicator(),
              )
            : Semantics(
                button: true,
                value: context.localizations.press_twice_to_open,
                child: CustomizedContentDocumentSimple(
                  title: DocumentUtils.getDocumentFullName(
                    doc.docName,
                    documentType,
                    doc.signFrmt,
                  ),
                  subtitle: doc.getFileSize(context),
                  semanticTitle: doc.docName,
                  semanticSubtitle: doc.getFileSize(context),
                  icon: Assets.iconChevronRight,
                  onTap: () => _downloadDocument(
                    context,
                  ),
                ),
              ),
      ),
    );
  }

  void _downloadDocument(BuildContext context) {
    DocumentEvent event;
    switch (documentType) {
      case DocumentType.doc:
        event = DocumentEvent.getDocument(
          docId: doc.docId,
          docName: doc.docName,
        );
        break;
      case DocumentType.signDoc:
        event = DocumentEvent.getSignedDocument(
          docId: doc.docId,
          docName: doc.docName,
          signFormat: doc.signFrmt,
        );
        break;
      case DocumentType.signReport:
        event = DocumentEvent.getSignReport(
          docId: doc.docId,
          docName: doc.docName,
        );
        break;
    }

    context.read<DocumentBloc>().add(event);
  }
}
