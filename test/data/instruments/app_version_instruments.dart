import 'package:portafirmas_app/data/models/app_version_remote_entity.dart';
import 'package:portafirmas_app/data/models/push_petition_remote_entity.dart';

import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/authuser_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/user_role_entity.dart';

import '../../presentation/instruments/requests_instruments.dart';

class LiteralsPushVersion {
  static const token = 'token';
  static const uuid = 'uuid';
  static const sessionId = 'sessionId';
  static const nif = 'nif';
  static const requestId = 'requestId';
  static const dni = 'dni';
  static const id = 'id';
  static const name = 'name';
  static const signFormat = 'PDF';
}

AppVersionRemoteEntity getAppVersionRemoteEntity() =>
    const AppVersionRemoteEntity(
      minAppVersion: 'minAppVersion',
      warningAppVersion: 'warningAppVersion',
    );

List<AuthDataEntity> getListAuthDataEntity() => [
      AuthDataEntity(
        authUser: AuthUserEntity(
          id: 'id',
          dni: 'dni',
          authUsername: 'authUsername',
        ),
        type: 'type',
        startDate: 'startDate',
      ),
    ];

PushPetitionRemoteEntity givenPushPetitionRemoteEntity() =>
    const PushPetitionRemoteEntity(
      platform: 1,
      pushToken: LiteralsPushVersion.token,
      uuid: LiteralsPushVersion.uuid,
      nif: LiteralsPushVersion.nif,
    );

SignRequestPetitionRemoteEntity getSignRequestPetitionRemoteEntity() =>
    SignRequestPetitionRemoteEntity(
      requestId: 'requestId',
      signDocs: givenSignDocPetitionRemoteEntityList(),
    );

List<SignRequestPetitionRemoteEntity>
    getListSignRequestPetitionRemoteEntity() => List.generate(
          1,
          (index) => getSignRequestPetitionRemoteEntity(),
        );

PreSignReqEntity getPreSignReqEntity() => PreSignReqEntity(
      requestId: 'requestId',
      status: true,
      signDocs: givenPreSignDocEntityList(),
    );
UserRoleEntity getUserRoleEntity() => const UserRoleEntity(
      idEntity: 'idEntity',
      roleNameEntity: 'roleNameEntity',
      userNameEntity: 'userNameEntity',
      dniEntity: 'dniEntity',
    );

List<UserRoleEntity> getListUserRoleEntity() =>
    List.generate(1, (index) => getUserRoleEntity());
