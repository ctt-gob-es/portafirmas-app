
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/data/models/sign_doc_petition_remote_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_document.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_request.dart';

part 'sign_request_cert_petition_remote_entity.freezed.dart';

@freezed
class SignRequestPetitionRemoteEntity with _$SignRequestPetitionRemoteEntity {
  const factory SignRequestPetitionRemoteEntity({
    required String requestId,

    /// all the docs to sign
    required List<SignDocPetitionRemoteEntity> signDocs,
    //only for post-sign
    bool? status,
  }) = _SignRequestPetitionRemoteEntity;

  factory SignRequestPetitionRemoteEntity.fromDetailRequest(
    RequestEntity request,
  ) =>
      SignRequestPetitionRemoteEntity(
        requestId: request.id,
        signDocs: request.listDocs
                ?.map((e) => SignDocPetitionRemoteEntity(
                      docId: e.docId,
                      signFrmt: e.signFrmt,
                      signAlgo: e.signAlgo,
                      params: e.params,
                    ))
                .toList() ??
            [],
      );

  factory SignRequestPetitionRemoteEntity.fromSignedRequest(
    SignedRequest request,
  ) {
    List<SignedDocument>? docs = request.signedDocuments;

    return SignRequestPetitionRemoteEntity(
      requestId: request.id,
      status: request.status,
      signDocs: docs != null
          ? docs
              .map((doc) => SignDocPetitionRemoteEntity(
                    docId: doc.id,
                    signFrmt: doc.signFrmt,
                    signAlgo: doc.signAlgo,
                    params: doc.params,
                    cop: doc.cop,
                    needCnf: doc.needCnf,
                    signResult: doc.signData,
                  ))
              .toList()
          : [],
    );
  }
}

extension SignRequestPetitionRemoteEntityExtension
    on SignRequestPetitionRemoteEntity {
  String get xmlString {
    String result = "<req id='$requestId'${_getStatus()}>";

    for (final SignDocPetitionRemoteEntity doc in signDocs) {
      result += doc.xmlString;
    }
    result += '</req>';

    return result;
  }

  String _getStatus() =>
      status != null ? " status=${(status == true) ? "'OK'" : "'KO'"}" : '';
}
