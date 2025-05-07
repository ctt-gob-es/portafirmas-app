/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';

part 'document_bloc.freezed.dart';
part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final RequestRepositoryContract _repository;
  DocumentBloc({required RequestRepositoryContract repositoryContract})
      : _repository = repositoryContract,
        super(DocumentState.initial()) {
    on<DocumentEvent>((event, emit) async {
      await event.when(
        getDocument: (String docId, String docName) =>
            _getDocument(docId, docName, emit),
        getSignedDocument: (String docId, String docName, String signFormat) =>
            _getSignedDocument(docId, docName, signFormat, emit),
        getSignReport: (String docId, String docName) =>
            _getSignReport(docId, docName, emit),
      );
    });
  }

  FutureOr<void> _getDocument(
    String docId,
    String docName,
    Emitter<DocumentState> emit,
  ) async {
    emit(state.copyWith(
      docId: docId,
      docType: DocumentType.doc,
      downloadStatus: const ScreenStatus.loading(),
    ));

    final result = await _repository.getDocument(
      docId: docId,
      docName: docName,
    );
    result.when(
      failure: (error) => emit(DocumentState.initial()
          .copyWith(downloadStatus: const ScreenStatus.error())),
      success: (filePath) {
        emit(state.copyWith(
          downloadStatus: const ScreenStatus.success(),
          filePath: filePath,
          docId: docId,
        ));
        emit(DocumentState.initial());
      },
    );
  }

  FutureOr<void> _getSignedDocument(
    String docId,
    String docName,
    String signFormat,
    Emitter<DocumentState> emit,
  ) async {
    final docUniqueId = '$docId${SignReport.signSuffix}';
    emit(state.copyWith(
      docId: docUniqueId,
      docType: DocumentType.signDoc,
      downloadStatus: const ScreenStatus.loading(),
    ));

    final result = await _repository.getSignedDocument(
      docId: docId,
      docName: docName,
      signFormat: signFormat,
    );
    result.when(
      failure: (error) => emit(DocumentState.initial()
          .copyWith(downloadStatus: const ScreenStatus.error())),
      success: (filePath) {
        emit(state.copyWith(
          downloadStatus: const ScreenStatus.success(),
          filePath: filePath,
        ));
        emit(DocumentState.initial());
      },
    );
  }

  FutureOr<void> _getSignReport(
    String docId,
    String docName,
    Emitter<DocumentState> emit,
  ) async {
    final docUniqueId = '$docId${SignDocument.reportSuffix}';
    emit(state.copyWith(
      docId: docUniqueId,
      docType: DocumentType.signReport,
      downloadStatus: const ScreenStatus.loading(),
    ));

    final result = await _repository.getSignReport(
      docId: docId,
      docName: docName,
    );
    result.when(
      failure: (error) => emit(DocumentState.initial()
          .copyWith(downloadStatus: const ScreenStatus.error())),
      success: (filePath) {
        emit(state.copyWith(
          downloadStatus: const ScreenStatus.success(),
          filePath: filePath,
        ));
        emit(DocumentState.initial());
      },
    );
  }
}
