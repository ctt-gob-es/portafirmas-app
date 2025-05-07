/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:convert';

import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/models/certificate_local_entity.dart';
import 'package:portafirmas_app/data/models/pre_login_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/auth_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/models/result_login_certificate.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/authentication_repository_contract.dart';

class AuthRepository implements AuthenticationRepositoryContract {
  final AuthRemoteDataSourceContract _authRemoteDataSource;
  final AuthLocalDataSourceContract _authLocalDataSource;

  final CertificateHandlerLocalDataSourceContract
      _certificateHandlerLocalDataSourceContract;

  AuthRepository(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._certificateHandlerLocalDataSourceContract,
  );

  @override
  Future<ResultLoginDefaultCertificate> loginWithDefaultCertificate() async {
    try {
      var certificate = await _certificateHandlerLocalDataSourceContract
          .getDefaultCertificate();

      if (certificate == null) {
        return const ResultLoginDefaultCertificate.noDefaultCertificate();
      } else {
        final dni = await _loginWithCertificate(certificate);

        return ResultLoginDefaultCertificate.success(dni);
      }
    } catch (e) {
      return ResultLoginDefaultCertificate.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<String>> loginWithCertificate(BuildContext context) async {
    try {
      final result = await loginWithDefaultCertificate();

      return result.when(
        failure: (error) => Result.failure(
          error: error,
        ),
        success: (dni) => Result.success(dni),
        noDefaultCertificate: () async {
          if (defaultTargetPlatform == TargetPlatform.android) {
            final certificate = await _certificateHandlerLocalDataSourceContract
                .selectDefaultCertificate(context: context);

            if (certificate == null) {
              return const Result.failure(
                error: RepositoryError.canceledByUser(),
              );
            }
            final dni = await _loginWithCertificate(certificate);

            return Result.success(dni);
          } else {
            return const Result.failure(
              error: RepositoryError.noCertificatesIOS(),
            );
          }
        },
      );
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<bool>> logOut(bool deleteLastAuthMethod) async {
    try {
      final sessionId = await _authLocalDataSource.retrieveSessionId();

      if (sessionId == null) {
        return const Result.failure(error: RepositoryError.serverError());
      }

      await _authRemoteDataSource.logOut(sessionId: sessionId);
      await _authLocalDataSource.removeSessionId();
      if(deleteLastAuthMethod) {
         await _authLocalDataSource.deleteLastAuthMethod();
      }
     
      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<LoginClaveEntity>> loginWithClave() async {
    try {
      final response = await _authRemoteDataSource.loginWithClave();

      return Result.success(response.toLoginClaveEntity());
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<void> saveSessionId({required String sessionId}) {
    return _authLocalDataSource.saveSessionId(sessionId);
  }

  @override
  Future<Result<bool>> isUserFirstTime() async {
    final result = await _authLocalDataSource.isUserFirstTime();

    return Result.success(result);
  }

  @override
  Future<Result<bool>> setFirstTime() async {
    await _authLocalDataSource.setFirstTime();

    return const Result.success(true);
  }

  @override
  Future<Result<AuthMethod?>> getLastAuthMethod() async {
    try {
      final data = await _authLocalDataSource.getLastAuthMethod();

      return Result.success(parseAuthMethodFromString(data));
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<bool>> setLastAuthMethod(AuthMethod authMethod) async {
    try {
      await _authLocalDataSource.setLastAuthMethod(authMethod.toStringLabel());

      return const Result.success(true);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  Future<String> _loginWithCertificate(
    CertificateLocalEntity certificate,
  ) async {
    final preLogin = await _doPreLoginAndSaveSessionId();
    final sessionId = preLogin.cookie;
    final toSign = base64Decode(preLogin.loginRequest);

    final signedData = await _certificateHandlerLocalDataSourceContract
        .signWithDefaultCertificate(
      toSign,
      PfSignAlgorithm.sha256rsa,
    );

    final certBase64 = base64Encode(certificate.certEncoded);
    final loginTokenBase64 = base64Encode(signedData);

    await _authLocalDataSource.savePublicKey(certBase64);

    final dni = await _authRemoteDataSource.loginWithCertificate(
      sessionId: sessionId,
      loginTokenSignedBase64: loginTokenBase64,
      publicKeyBase64: certBase64,
    );

    return dni;
  }

  Future<PreLoginRemoteEntity> _doPreLoginAndSaveSessionId() async {
    PreLoginRemoteEntity preLogin = await _authRemoteDataSource.preLogin();

    await _authLocalDataSource.saveSessionId(preLogin.cookie);

    return preLogin;
  }
}
