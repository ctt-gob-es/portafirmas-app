
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
import 'package:portafirmas_app/domain/models/annexes_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/customized_content_document_widget.dart';

class AnnexeWidget extends StatelessWidget {
  final AnnexesEntity annexe;
  final DocumentType docType;
  const AnnexeWidget({
    super.key,
    required this.annexe,
    this.docType = DocumentType.doc,
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
                  state.isDocDownloaded(annexe.annexeId, DocumentType.doc)) {
                await OpenFilex.open(state.filePath ?? '');
              }
            },
            error: (_) => ErrorUtils.showErrorOverlay(context),
          );
        },
        builder: (context, state) => state.isLoadingDoc(
          annexe.annexeId,
          docType,
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
                    annexe.annexeName,
                    docType,
                    '',
                  ),
                  subtitle: annexe.getFileSize(context),
                  semanticTitle: annexe.annexeName,
                  semanticSubtitle: annexe.getFileSize(context),
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
    context.read<DocumentBloc>().add(DocumentEvent.getDocument(
          docId: annexe.annexeId,
          docName: annexe.annexeName,
        ));
  }
}
