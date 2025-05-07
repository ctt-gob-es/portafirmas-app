import 'package:portafirmas_app/data/models/accept_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/accept_authorization_value_remote_entity.dart';
import 'package:portafirmas_app/data/models/add_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/add_validator_remote_entity.dart';
import 'package:portafirmas_app/data/models/app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/approved_request_remote_entity.dart';
import 'package:portafirmas_app/data/models/approved_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/auth_data_remote_entity.dart';
import 'package:portafirmas_app/data/models/auth_sender_user_remote_entity.dart';
import 'package:portafirmas_app/data/models/authuser_remote_entity.dart';
import 'package:portafirmas_app/data/models/login_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/post_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/post_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/post_sign_req_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_login_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_sign_req_remote_entity.dart';
import 'package:portafirmas_app/data/models/push_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/register_push_remote_entity.dart';
import 'package:portafirmas_app/data/models/remove_validator_remote_entity.dart';
import 'package:portafirmas_app/data/models/remove_validator_value_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_app_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/request_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_authorization_value_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoke_requests_remote_entity.dart';
import 'package:portafirmas_app/data/models/revoked_request_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_doc_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/update_push_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_app_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_request_app_remote_entity.dart';
import 'package:portafirmas_app/data/models/user_role_remote_entity.dart';
import 'package:portafirmas_app/data/models/users_search_remote_entity.dart';
import 'package:portafirmas_app/data/models/validate_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/validate_petitions_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/validator_list_remote_entity.dart';
import 'package:portafirmas_app/data/models/validator_user_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/auth_observations_entity.dart';
import 'package:portafirmas_app/domain/models/auth_sender_entity.dart';
import 'package:portafirmas_app/domain/models/authuser_entity.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/request_list_entity.dart';
import 'package:portafirmas_app/domain/models/validator_entity.dart';
import 'package:portafirmas_app/domain/models/validator_user_entity.dart';

RequestListRemoteEntity givenRequestListRemoteEntity() =>
    RequestListRemoteEntity(
      count: '20',
      requestList: givenRequestRemoteEntityList(),
    );

PushPetitionRemoteEntity givenPushPetitionRemoteEntity() =>
    const PushPetitionRemoteEntity(
      platform: 1,
      pushToken: 'pushToken',
      uuid: 'uuid',
      nif: 'nif',
    );

RegisterPushRemoteEntity givenRegisterPushRemoteEntity() =>
    const RegisterPushRemoteEntity(
      status: 'status',
    );
PreSignRemoteEntity givenPreSignRemoteEntity() =>
    const PreSignRemoteEntity(signRequests: [
      PreSignReqRemoteEntity(
        requestId: 'requestId',
        status: true,
        signDocs: [],
      ),
    ]);

PostSignClaveRemoteEntity givenPostSignClaveRemoteEntity() =>
    const PostSignClaveRemoteEntity(
      status: true,
    );

RemoveUserRemoteEntity givenRemoveUserRemoteEntity() =>
    const RemoveUserRemoteEntity(
      result: RemoveValidatorResultValue(
        value: 'value',
      ),
    );

AddUserRemoteEntity givenAddUserRemoteEntity() => const AddUserRemoteEntity(
      result: RemoveValidatorResultValue(
        value: 'value',
      ),
    );
List<SignRequestPetitionRemoteEntity> getSignRequestPetitionRemoteEntity() => [
      const SignRequestPetitionRemoteEntity(
        requestId: 'requestId',
        signDocs: [
          SignDocPetitionRemoteEntity(
            docId: 'docId',
            signFrmt: 'signFrmt',
            signAlgo: 'signAlgo',
            params: 'params',
          ),
        ],
      ),
    ];

PostSignRemoteEntity getPostSignRemoteEntity() => const PostSignRemoteEntity(
      signedRequests: [
        PostSignReqRemoteEntity(
          requestId: 'requestId',
          status: true,
        ),
      ],
    );

PreSignClaveRemoteEntity getPreSignClaveRemoteEntity() =>
    const PreSignClaveRemoteEntity(
      status: true,
      signUrl: 'signUrl',
    );
UpdatePushRemoteEntity givenUpdatePushRemoteEntity() =>
    const UpdatePushRemoteEntity(
      status: 'status',
    );
UserAppListRemoteEntity givenUserAppListRemoteEntity() =>
    const UserAppListRemoteEntity(userAppList: [
      UserRequestAppRemoteEntity(id: 'id', appName: 'appName'),
      UserRequestAppRemoteEntity(id: 'id2', appName: 'appName2'),
    ]);
AppListRemoteEntity getAppListRemoteEntity() =>
    const AppListRemoteEntity(appList: [
      RequestAppRemoteEntity(id: 'id', appName: 'appName'),
      RequestAppRemoteEntity(id: 'id2', appName: 'appName2'),
    ]);

RequestListEntity givenRequestListEntity() =>
    RequestListEntity(count: 20, requests: givenRequestEntityList());

RequestRemoteEntity givenRequestRemoteEntity() => const RequestRemoteEntity(
      id: 'id',
      type: 'type',
      subject: 'subject',
      sender: 'sender',
      date: 'date',
      expirationDate: 'expirationDate',
    );
List<UserRoleRemoteEntity> getUserRoleRemoteEntityList() => [
      const UserRoleRemoteEntity(
        id: 'id',
        roleName: 'roleName',
        userName: 'userName',
        dni: 'dni',
      ),
    ];
List<UsersSearchRemoteEntity> getUsersSearchRemoteEntityList() => [
      const UsersSearchRemoteEntity(
        id: 'id',
        dni: 'dni',
        name: 'name',
      ),
    ];
RevokeRequestsRemoteEntity getRevokeRequestsRemoteEntity() =>
    const RevokeRequestsRemoteEntity(
      revokedRequests: [
        RevokedRequestRemoteEntity(
          id: 'id',
          status: 'status',
        ),
      ],
    );
ValidatePetitionsListRemoteEntity getValidatePetitionsListRemoteEntity() =>
    const ValidatePetitionsListRemoteEntity(validatePetitions: [
      ValidatePetitionRemoteEntity(
        id: 'id',
        status: 'ok',
      ),
    ]);

ApproveRequestsRemoteEntity getApproveRequestsRemoteEntity() =>
    const ApproveRequestsRemoteEntity(approvedRequest: [
      ApprovedRequestRemoteEntity(id: 'id', status: 'status'),
    ]);

const String entryDate1String = '10/11/2023 13:35:53';
DateTime entryDate1Date = DateTime(2023, 11, 10, 13, 35, 53);
const String exDate1String = '25/10/2050 23:59:00';
DateTime exDate1Date = DateTime(2050, 10, 25, 23, 59, 00);
String isLoggedWithClave =
    'UserAuthStatus.loggedIn(dni: 1234567A, loggedWithClave: false)';

List<RequestRemoteEntity> givenRequestRemoteEntityList() => const [
      RequestRemoteEntity(
        id: '0abc1',
        priority: '2',
        workflow: 'workflow',
        forward: 'false',
        type: 'FIRMA',
        subject: 'Subject Example',
        sender: 'Sender Name',
        view: 'NUEVO',
        date: entryDate1String,
        expirationDate: exDate1String,
      ),
      RequestRemoteEntity(
        id: '0abc2',
        priority: '1',
        workflow: 'workflow',
        forward: 'false',
        type: 'VISTOBUENO',
        subject: 'Subject Example',
        sender: 'Sender Name',
        view: 'NUEVO',
        date: entryDate1String,
        expirationDate: exDate1String,
      ),
      RequestRemoteEntity(
        id: '0abc3',
        priority: '1',
        workflow: 'workflow',
        forward: 'false',
        type: 'FIRMA',
        subject: 'Subject Example',
        sender: 'Sender Name',
        view: 'NUEVO',
        date: entryDate1String,
        expirationDate: exDate1String,
      ),
      RequestRemoteEntity(
        id: '0abc4',
        priority: '4',
        workflow: 'workflow',
        forward: 'false',
        type: 'FIRMA',
        subject: 'Subject Example',
        sender: 'Sender Name',
        view: 'LEIDO',
        date: entryDate1String,
        expirationDate: null,
      ),
      RequestRemoteEntity(
        id: '0abc5',
        priority: '3',
        workflow: 'workflow',
        forward: 'false',
        type: 'VISTOBUENO',
        subject: 'Subject Example',
        sender: 'Sender Name',
        view: 'LEIDO',
        date: entryDate1String,
        expirationDate: null,
      ),
    ];

RequestEntity givenRequestEntity() => RequestEntity(
  
      id: '0abc1',
      priority: RequestPriority.high,
      type: RequestType.signature,
      subject: 'Subject Example',
      from: 'Sender Name',
      lastModificationDate: entryDate1Date,
      expirationDate: exDate1Date,
    );

RequestEntity givenRequestValidatedEntity() => RequestEntity(
      id: '0abc1',
      priority: RequestPriority.high,
      type: RequestType.signature,
      subject: 'Subject Example',
      from: 'Sender Name',
      lastModificationDate: entryDate1Date,
      expirationDate: exDate1Date,
    );

RequestEntity givenRequestEntityNotExpire() => RequestEntity(
      id: '0abc1',
      priority: RequestPriority.high,
      type: RequestType.signature,
      subject: 'Subject Example',
      from: 'Sender Name',
      lastModificationDate: entryDate1Date,
      expirationDate: null,
    );

List<RequestEntity> givenRequestEntityList() => [
      RequestEntity(
        id: '0abc1',
        priority: RequestPriority.high,
        type: RequestType.signature,
        subject: 'Subject Example',
        from: 'Sender Name',
        view: true,
        lastModificationDate: entryDate1Date,
        expirationDate: exDate1Date,
      ),
      RequestEntity(
        id: '0abc2',
        priority: RequestPriority.normal,
        type: RequestType.approval,
        subject: 'Subject Example',
        from: 'Sender Name',
        view: true,
        lastModificationDate: entryDate1Date,
        expirationDate: exDate1Date,
      ),
      RequestEntity(
        id: '0abc3',
        priority: RequestPriority.normal,
        type: RequestType.signature,
        subject: 'Subject Example',
        from: 'Sender Name',
        view: true,
        lastModificationDate: entryDate1Date,
        expirationDate: exDate1Date,
      ),
      RequestEntity(
        id: '0abc4',
        priority: RequestPriority.urgent,
        type: RequestType.signature,
        subject: 'Subject Example',
        from: 'Sender Name',
        view: false,
        lastModificationDate: entryDate1Date,
        expirationDate: null,
      ),
      RequestEntity(
        id: '0abc5',
        priority: RequestPriority.veryHigh,
        type: RequestType.approval,
        subject: 'Subject Example',
        from: 'Sender Name',
        view: false,
        lastModificationDate: entryDate1Date,
        expirationDate: null,
      ),
    ];

List<ValidatorRemoteEntity> getListValidatorRemoteEntity() => List.generate(
      2,
      (i) => const ValidatorRemoteEntity(
        validatorUser: ValidatorUserRemoteEntity(
          id: 'id',
          dni: 'dni',
          validatorUsername: 'validatorUsername',
        ),
        forapps: 'forapps',
      ),
    );
List<ValidatorEntity> givenValidatorEntityList() => List.generate(
      2,
      (index) => ValidatorEntity(
        validatorUser: ValidatorUserEntity(dni: 'dni', id: 'id', name: 'name'),
      ),
    );

List<ValidatorEntity> givenValidatorUser() => [
      ValidatorEntity(
        validatorUser: ValidatorUserEntity(
          dni: '1234567A',
          id: '1208',
          name: 'Alberto',
        ),
      ),
    ];

const String prueba = 'Prueba';
const String id = '1111';

const validator = UserSearch(
  dni: '1234567A',
  id: '1205',
  name: 'Alberto Prueba',
);

List<UserSearch> givenValidatorUserBySearch() => [
      const UserSearch(
        dni: '1234567A',
        id: '1201',
        name: 'Alberto Prueba',
      ),
      const UserSearch(
        dni: '1234568A',
        id: '1202',
        name: 'Maria Prueba',
      ),
      const UserSearch(
        dni: '1234569A',
        id: '1203',
        name: 'Prueba Prueba',
      ),
      const UserSearch(
        dni: '1234563A',
        id: '1204',
        name: 'Prueba',
      ),
    ];
List<AuthDataEntity> givenAuthorization() => [
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3395', dni: '111111F', username: 'user1'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '297',
        type: 'DELEGADO',
        state: 'revoked',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
    ];
AuthDataEntity givenInitialAuth() => AuthDataEntity(
      user: AuthSenderUseEntity(id: '', dni: '', username: ''),
      authUser: AuthUserEntity(
        id: '',
        dni: '',
        authUsername: '',
      ),
      observations: AuthObservationsEntity(observations: ''),
      id: '',
      type: '',
      state: '',
      startDate: '',
      revDate: '',
      sended: true,
    );

List<AuthDataEntity> givenRevokedAuthSended() => [
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3395', dni: '111111F', username: 'user1'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '297',
        type: 'DELEGADO',
        state: 'revoked',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
    ];

List<AuthDataEntity> givenAcceptedAuthReceived() => [
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3395', dni: '111111F', username: 'user1'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'accepted',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
    ];

List<AuthDataEntity> givenAuthDataDetailsList() => [
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3395', dni: '111111F', username: 'user1'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'revoked',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: false,
      ),
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3390', dni: '111111G', username: 'user2'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'revoked',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3380', dni: '111111A', username: 'user3'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'accepted',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3381', dni: '111111C', username: 'user4'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'accepted',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: false,
      ),
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3380', dni: '111111L', username: 'user5'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'pending',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: true,
      ),
      AuthDataEntity(
        user:
            AuthSenderUseEntity(id: '3381', dni: '111111B', username: 'user6'),
        authUser: AuthUserEntity(
          id: '3396',
          dni: '222222F',
          authUsername: 'authuser1',
        ),
        observations: AuthObservationsEntity(observations: 'prueba'),
        id: '290',
        type: 'DELEGADO',
        state: 'pending',
        startDate: '21/02/2023',
        revDate: '22/02/2023',
        sended: false,
      ),
    ];

List<AuthDataEntity> givenAuthDataList() => [
      AuthDataEntity(
        user: AuthSenderUseEntity(id: 'id', dni: 'dni', username: 'username'),
        authUser:
            AuthUserEntity(id: 'id', dni: 'dni', authUsername: 'authUsername'),
        observations: AuthObservationsEntity(observations: 'observations'),
        id: 'id',
        type: 'type',
        state: 'state',
        startDate: 'startdate',
        revDate: 'revdate',
        sended: true,
      ),
      AuthDataEntity(
        user: AuthSenderUseEntity(id: 'id', dni: 'dni', username: 'username'),
        authUser:
            AuthUserEntity(id: 'id', dni: 'dni', authUsername: 'authUsername'),
        observations: AuthObservationsEntity(observations: 'observations'),
        id: 'id',
        type: 'type',
        state: 'state',
        startDate: 'startdate',
        revDate: 'revdate',
        sended: false,
      ),
    ];

List<AuthDataEntity> givenAuthDataSendList() => List.generate(
      2,
      (index) => AuthDataEntity(
        user: AuthSenderUseEntity(id: 'id', dni: 'dni', username: 'username'),
        authUser:
            AuthUserEntity(id: 'id', dni: 'dni', authUsername: 'authUsername'),
        observations: AuthObservationsEntity(observations: 'observations'),
        id: 'id',
        type: 'type',
        state: 'state',
        startDate: 'startdate',
        revDate: 'revdate',
        sended: true,
      ),
    );
List<AuthDataRemoteEntity> givenAuthDataRemoteEntityList() => List.generate(
      2,
      (index) => const AuthDataRemoteEntity(
        user: AuthSenderUserRemoteEntity(
          id: 'id',
          dni: 'dni',
          username: 'username',
        ),
        authuser: AuthUserRemoteEntity(
          id: 'id',
          dni: 'dni',
          authUsername: 'authUsername',
        ),
        id: 'id',
        type: 'type',
        state: 'state',
        startdate: 'startdate',
      ),
    );

List<AuthDataEntity> givenAuthDataReceivedList() => List.generate(
      2,
      (index) => AuthDataEntity(
        user: AuthSenderUseEntity(id: 'id', dni: 'dni', username: 'username'),
        authUser:
            AuthUserEntity(id: 'id', dni: 'dni', authUsername: 'authUsername'),
        observations: AuthObservationsEntity(observations: 'observations'),
        id: 'id',
        type: 'type',
        state: 'state',
        startDate: 'startdate',
        revDate: 'revdate',
        sended: false,
      ),
    );

AddAuthorizationRemoteEntity getAddAuthorizationRemoteEntity() =>
    const AddAuthorizationRemoteEntity(
      result: RemoveValidatorResultValue(
        value: 'value',
      ),
    );

RevokeAuthRemoteEntity getRevokeAuthRemoteEntity() =>
    const RevokeAuthRemoteEntity(
      result: RevokeAuthResultValue(
        value: 'value',
      ),
    );

AcceptAuthRemoteEntity getAcceptAuthRemoteEntity() =>
    const AcceptAuthRemoteEntity(
      result: AcceptAuthResultValue(
        value: 'value',
      ),
    );
NewAuthorizationUserEntity newUserEntity() => NewAuthorizationUserEntity(
      type: '',
      nif: '',
      id: '',
      observations: '',
      startDate: '',
      expDate: '',
    );

NewAuthorizationUserEntity newUserEntityTest() => NewAuthorizationUserEntity(
      type: 'DELEGADO',
      nif: '1234567A',
      id: '1201',
      observations: 'observations',
      startDate: entryDate1String,
      expDate: exDate1String,
    );

CertificateEntity certificate = CertificateEntity(
  serialNumber: 'serialNumber',
  alias: 'alias',
  holderName: 'holderName',
  emitterName: 'emitterName',
  usages: [],
  expirationDate: entryDate1Date,
);

Map<RequestEntity, bool> requestSelected = {
  RequestEntity(
    id: '0abc1',
    priority: RequestPriority.high,
    type: RequestType.signature,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: true,
    lastModificationDate: entryDate1Date,
    expirationDate: exDate1Date,
  ): true,
};
Map<RequestEntity, bool> requestListSelected = {
  RequestEntity(
    id: '0abc1',
    priority: RequestPriority.high,
    type: RequestType.signature,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: true,
    lastModificationDate: entryDate1Date,
    expirationDate: exDate1Date,
  ): true,
  RequestEntity(
    id: '0abc2',
    priority: RequestPriority.normal,
    type: RequestType.approval,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: true,
    lastModificationDate: entryDate1Date,
    expirationDate: exDate1Date,
  ): true,
  RequestEntity(
    id: '0abc3',
    priority: RequestPriority.normal,
    type: RequestType.signature,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: true,
    lastModificationDate: entryDate1Date,
    expirationDate: exDate1Date,
  ): true,
  RequestEntity(
    id: '0abc4',
    priority: RequestPriority.urgent,
    type: RequestType.signature,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: false,
    lastModificationDate: entryDate1Date,
    expirationDate: null,
  ): true,
  RequestEntity(
    id: '0abc5',
    priority: RequestPriority.veryHigh,
    type: RequestType.approval,
    subject: 'Subject Example',
    from: 'Sender Name',
    view: false,
    lastModificationDate: entryDate1Date,
    expirationDate: null,
  ): true,
};

PreLoginRemoteEntity givenPreLoginRemoteEntity = const PreLoginRemoteEntity(
  cookie: 'sessionId',
  loginRequest: 'loginRequest',
);

LoginClaveRemoteEntity givenLoginClaveRemoteEntity =
    const LoginClaveRemoteEntity(url: 'url', cookies: {});
