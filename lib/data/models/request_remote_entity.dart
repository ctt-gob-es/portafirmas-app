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
import 'package:portafirmas_app/app/utils/server_date_utils.dart';
import 'package:portafirmas_app/data/models/annexes_remote_entity.dart';
import 'package:portafirmas_app/data/models/document_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_line_remote_entity.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/reject_status.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_entity.dart';

part 'request_remote_entity.freezed.dart';

@freezed
class RequestRemoteEntity with _$RequestRemoteEntity {
  const factory RequestRemoteEntity({
    required String id,
    required String type,
    required String subject,
    required String sender,
    required String date,
    required String? expirationDate,
    String? priority,
    String? workflow,
    String? forward,
    String? view,
    String? ref,
    String? application,
    String? signLinesType,
    String? message,
    List<SignLineRemoteEntity>? signLines,
    List<DocumentRemoteEntity>? listDocs,
    List<AnnexesRemoteEntity>? annexesList,
    String? rejectStatus,
  }) = _RequestRemoteEntity;

  factory RequestRemoteEntity.fromRequestList(Map<String, dynamic> json) {
    final jsonDocs = json['docs']['doc'];

    return RequestRemoteEntity(
      id: json['id'],
      priority: json['priority'],
      workflow: json['workflow'],
      forward: json['forward'],
      type: json['type'],
      subject: json['subj']['__cdata'],
      sender: json['snder']['__cdata'],
      view: json['view']['\$t'],
      date: json['date']['\$t'],
      expirationDate: json['expdate']?['\$t'],
      listDocs: jsonDocs != null
          ? jsonDocs is List
              ? jsonDocs.map((e) => DocumentRemoteEntity.fromJson(e)).toList()
              : [
                  DocumentRemoteEntity.fromJson(
                    jsonDocs as Map<String, dynamic>,
                  ),
                ]
          : null,
      rejectStatus: json['status'] as String?,
    );
  }

  factory RequestRemoteEntity.fromRequestDetail(Map<String, dynamic> json) {
    final jsonDocs = json['docs']['doc'];
    final jsonSignLines = json['sgnlines']['sgnline'];
    final jsonAnnexesList = json['attachedList'];
    final jsonAnnexes =
        jsonAnnexesList != null ? jsonAnnexesList['attached'] : null;

    return RequestRemoteEntity(
      id: json['id'],
      sender: json['snders']['snder']['__cdata'],
      subject: json['subj']['__cdata'],
      ref: json['ref']['__cdata'],
      application: json['app']['__cdata'],
      date: json['date']['\$t'],
      expirationDate: json['expdate']?['\$t'],
      type: json['type'],
      message: json['msg']?['__cdata'].replaceAll('\\r\\\\n', '<br>'),
      signLinesType: json['signlinestype']['\$t'],
      signLines: jsonSignLines is List
          ? jsonSignLines.map((e) => SignLineRemoteEntity.fromJson(e)).toList()
          : [
              SignLineRemoteEntity.fromJson(
                jsonSignLines as Map<String, dynamic>,
              ),
            ],
      listDocs: jsonDocs != null
          ? jsonDocs is List
              ? jsonDocs.map((e) => DocumentRemoteEntity.fromJson(e)).toList()
              : [
                  DocumentRemoteEntity.fromJson(
                    jsonDocs as Map<String, dynamic>,
                  ),
                ]
          : null,
      annexesList: jsonAnnexes != null
          ? (jsonAnnexes is List
              ? jsonAnnexes.map((e) => AnnexesRemoteEntity.fromJson(e)).toList()
              : [
                  AnnexesRemoteEntity.fromJson(
                    jsonAnnexes as Map<String, dynamic>,
                  ),
                ])
          : null,
      rejectStatus: json['status'] as String?,
    );
  }
}

extension RequestRemoteEntityExtension on RequestRemoteEntity {
  RequestEntity toDetailRequestEntity() => RequestEntity(
        id: id,
        subject: subject,
        from: sender,
        priority: getPriority(),
        lastModificationDate: ServerDateUtils.parseFromServer(date),
        expirationDate: ServerDateUtils.tryParseFromServer(expirationDate),
        type: getType(),
        ref: ref,
        application: application,
        message: message,
        signLinesType: signLinesType,
        signLines: signLines?.map((e) => e.toSignLineEntity()).toList(),
        listDocs: listDocs?.map((e) => e.toDocumentEntity()).toList(),
        annexesList: annexesList?.map((e) => e.toAnnexesEntity()).toList(),
        view: getView(),
        rejectStatus: RejectStatus.fromValue(rejectStatus),
      );

  RequestEntity toRequestEntity() => RequestEntity(
        id: id,
        subject: subject,
        from: sender,
        view: getView(),
        priority: getPriority(),
        lastModificationDate: ServerDateUtils.parseFromServer(date),
        expirationDate: ServerDateUtils.tryParseFromServer(expirationDate),
        type: getType(),
        listDocs: listDocs?.map((e) => e.toDocumentEntity()).toList(),
        rejectStatus: RejectStatus.fromValue(rejectStatus),
      );

  bool getView() => (view != null && view == 'NUEVO') ? true : false;

  RequestType getType() {
    if (type == 'FIRMA') {
      return RequestType.signature;
    } else if (type == 'VISTOBUENO') {
      return RequestType.approval;
    } else {
      return RequestType.signature;
    }
  }

  RequestPriority getPriority() {
    if (priority == '1') {
      return RequestPriority.normal;
    } else if (priority == '2') {
      return RequestPriority.high;
    } else if (priority == '3') {
      return RequestPriority.veryHigh;
    } else if (priority == '4') {
      return RequestPriority.urgent;
    } else {
      return RequestPriority.normal;
    }
  }
}
