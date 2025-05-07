import 'dart:convert';
import 'dart:typed_data';

import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/models/sign_doc_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/data/repositories/models/user_role.dart';
import 'package:portafirmas_app/domain/models/annexes_entity.dart';
import 'package:portafirmas_app/domain/models/app_version_entity.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/document_entity.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/post_sign_clave_entity.dart';
import 'package:portafirmas_app/domain/models/post_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_clave_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_doc_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/request_app_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_entity.dart';
import 'package:portafirmas_app/domain/models/users_search_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/model/sign_data.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_document.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_request.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/filter_init_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/request_status.dart';

import '../../data/instruments/request_data_instruments.dart';

final RequestsStatus givenInitialStatusWithRequests = RequestsStatus(
  requestsCount: 20,
  requests: givenRequestEntityList(),
  screenStatus: const ScreenStatus.success(),
);

RequestFilters givenFiltersNotInitial = RequestFilters(
  pendingFilter: givenFilterNotInitial,
  signedFilter: givenFilterNotInitial,
  rejectedFilter: givenFilterNotInitial,
);

const RequestFilter givenFilterNotInitial = RequestFilter(
  order: OrderFilter.oldest,
  requestType: RequestTypeFilter.sign,
  timeInterval: TimeIntervalFilter.lastMonth,
  inputFilter: 'App',
  app: null,
);

const RequestFilter givenFilterNotInitialValidatorProfile = RequestFilter(
  order: OrderFilter.oldest,
  requestType: RequestTypeFilter.validated,
  timeInterval: TimeIntervalFilter.lastMonth,
  inputFilter: 'App',
  app: null,
);

FilterInitData givenFilterInitData = FilterInitData(
  requestStatus: RequestStatus.pending,
  initFilter: RequestFilter.initial(),
  isValidatorProfile: false,
);

RequestAppData givenRequestAppData =
    const RequestAppData(id: '1', name: 'name');

const String givenAnInputFiter = 'test';

List<UserRole> givenUserRolesList() => List.generate(
      3,
      (index) => UserRole(
        id: index.toString(),
        roleName: 'roleName',
        userName: 'userName $index',
        dni: 'dni: $index',
      ),
    );

RequestEntity givenDetailRequestEntity = RequestEntity(
  id: 'requestId',
  signLinesType: 'signLinesType',
  from: 'sender',
  subject: 'info',
  ref: 'ref',
  application: 'application',
  lastModificationDate: DateTime.now(),
  expirationDate: DateTime.now(),
  type: RequestType.signature,
  listDocs: givenDocumentEntityList(),
  signLines: givenSignLineEntityList(),
  priority: RequestPriority.high,
  annexesList: givenAnnexesEntityList(),
);

DocumentEntity givenDocumentEntity() => const DocumentEntity(
      docId: 'docId',
      docName: 'docName',
      docSize: '1000',
      signFrmt: 'PDF',
      signAlgo: 'SHA1',
      params: '',
    );

AnnexesEntity givenAnnexesEntity() => const AnnexesEntity(
      annexeId: 'docId',
      annexeName: 'docName',
      annexeSize: '1000',
      mediaType: 'PDF',
    );

List<DocumentEntity> givenDocumentEntityList() => List.generate(
      1,
      (index) => DocumentEntity(
        docId: index.toString(),
        docName: '${DocumentLiterals.annexe}docName$index',
        docSize: '34',
        signFrmt: 'PDF',
        signAlgo: 'SHA1',
        params: '',
      ),
    );

List<AnnexesEntity> givenAnnexesEntityList() => List.generate(
      1,
      (index) => AnnexesEntity(
        annexeId: index.toString(),
        annexeName: '${DocumentLiterals.annexe}docName$index',
        annexeSize: '34',
        mediaType: 'PDF',
      ),
    );

List<SignLineEntity> givenSignLineEntityList() => List.generate(
      3,
      (index) => const SignLineEntity(
        type: '',
        signName: [],
      ),
    );

List<RevokedRequestEntity> givenRevokedRequestEntityList() => List.generate(
      1,
      (index) => const RevokedRequestEntity(id: 'id', status: true),
    );

List<RevokedRequestEntity> givenKORevokedRequestEntityList() => List.generate(
      1,
      (index) => const RevokedRequestEntity(id: 'id', status: false),
    );

List<SignRequestPetitionRemoteEntity>
    givenSignRequestPetitionRemoteEntityList() => List.generate(
          1,
          (index) => SignRequestPetitionRemoteEntity(
            requestId: 'requestId',
            signDocs: givenSignDocPetitionRemoteEntityList(),
          ),
        );

List<SignRequestPetitionRemoteEntity>
    givenSignRequestPostSignPetitionRemoteEntityList() => List.generate(
          1,
          (index) => SignRequestPetitionRemoteEntity(
            requestId: 'requestId',
            signDocs: givenSignDocPostSignPetitionRemoteEntityList(),
            status: true,
          ),
        );

List<SignDocPetitionRemoteEntity> givenSignDocPetitionRemoteEntityList() =>
    List.generate(
      1,
      (index) => SignDocPetitionRemoteEntity(
        docId: index.toString(),
        signFrmt: 'PDF',
        signAlgo: 'SHA1',
        params: '',
      ),
    );
List<SignDocPetitionRemoteEntity>
    givenSignDocPostSignPetitionRemoteEntityList() => List.generate(
          1,
          (index) => SignDocPetitionRemoteEntity(
            docId: index.toString(),
            signFrmt: 'PDF',
            signAlgo: 'SHA1',
            params: '',
            signResult: givenSignData,
          ),
        );

List<PreSignReqEntity> givenPreSignReqEntityList() => List.generate(
      1,
      (index) => PreSignReqEntity(
        requestId: 'requestId',
        status: true,
        signDocs: givenPreSignDocEntityList(),
      ),
    );

List<PreSignDocEntity> givenPreSignDocEntityList() => List.generate(
      1,
      (index) => PreSignDocEntity(
        id: index.toString(),
        signOp: 'signOp',
        signFrmt: 'PDF',
        signAlgo: 'SHA1',
        params: '',
        preSignContent: base64Encode(Uint8List.fromList([1, 2, 3])),
        preSignEncoding: 'preSignEncoding',
        needPre: true,
        needData: false,
        signBase: 'signBase',
        time: null,
        pid: null,
      ),
    );

List<RequestEntity> givenDetailRequestEntityList() => List.generate(
      1,
      (index) => RequestEntity(
        id: 'requestId',
        signLinesType: 'signLinesType',
        from: 'sender',
        subject: 'info',
        ref: 'ref',
        application: 'application',
        lastModificationDate: DateTime.now(),
        expirationDate: DateTime.now(),
        type: RequestType.signature,
        listDocs: givenDocumentEntityList(),
        signLines: givenSignLineEntityList(),
        priority: RequestPriority.high,
      ),
    );

SignData givenSignData = const SignData(
  id: '0',
  signResultBase64: 'signResultBase64',
  preSignContent: 'preSignContent',
  needPre: true,
);

SignData givenSignDataFullContent = const SignData(
  id: '0',
  signResultBase64: 'signResultBase64',
  preSignContent: 'preSignContent',
  needPre: true,
  needData: true,
  preSignEncoding: 'preSignEncoding',
  signBase: 'signBase',
  time: 'time',
  pid: 'pid',
);

List<SignedDocument> givenSignedDocumentList() => List.generate(
      1,
      (index) => SignedDocument(
        id: index.toString(),
        signFrmt: 'PDF',
        signAlgo: 'SHA1',
        params: '',
        signData: givenSignData,
      ),
    );

SignedRequest givenSignedRequest = SignedRequest(
  id: 'requestId',
  status: true,
  signedDocuments: givenSignedDocumentList(),
);

List<PostSignReqEntity> givenPostSignReqEntityList() => List.generate(
      1,
      (index) => const PostSignReqEntity(
        requestId: 'requestId',
        status: true,
      ),
    );

List<ApprovedRequestEntity> givenApprovedRequestEntityList() => List.generate(
      1,
      (index) => const ApprovedRequestEntity(id: 'id', status: true),
    );

List<ValidatePetitionEntity> givenValidateRequestEntityList() => List.generate(
      1,
      (index) => const ValidatePetitionEntity(id: 'id', status: true),
    );

PreSignClaveEntity givenPreSignClaveEntity =
    const PreSignClaveEntity(status: true, signUrl: 'signUrl');

PostSignClaveEntity givenPostSignClaveEntity =
    const PostSignClaveEntity(status: true);

AppVersionEntity givenAppVersionEntity =
    const AppVersionEntity(minAppVersion: '2.0', warningAppVersion: '2.1');
RequestAppEntity getRequestAppEntity() => const RequestAppEntity(
      id: 'id',
      name: 'name',
    );

UsersSearchEntity getUsersSearchEntity() =>
    UsersSearchEntity(id: 'id', dni: 'dni', name: 'name');
List<RequestAppEntity> getListRequestAppEntity() =>
    List.generate(1, (index) => getRequestAppEntity());

List<UsersSearchEntity> getListUsersSearchEntity() =>
    List.generate(1, (index) => getUsersSearchEntity());
