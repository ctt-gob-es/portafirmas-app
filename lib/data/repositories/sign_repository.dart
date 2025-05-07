
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
import 'dart:typed_data';

import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/sign_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/models/post_sign_clave_entity.dart';
import 'package:portafirmas_app/domain/models/post_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_clave_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_req_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/sign_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/detail/model/sign_data.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_document.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_request.dart';

class SignRepository implements SignRepositoryContract {
  final SignRemoteDataSourceContract _signRemoteDataSource;
  final AuthLocalDataSourceContract _authLocalDataSource;
  final CertificateHandlerLocalDataSourceContract
      _certificateHandlerLocalDataSourceContract;

  SignRepository(
    this._signRemoteDataSource,
    this._authLocalDataSource,
    this._certificateHandlerLocalDataSourceContract,
  );

  @override
  Future<Result<List<PreSignReqEntity>>> preSignWithCert({
    required List<SignRequestPetitionRemoteEntity> signReqs,
  }) async {
    String sessionId = await _getSessionId() ?? '';
    if (sessionId.isEmpty) {
      const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      final result = await _signRemoteDataSource.preSignWithCert(
        sessionId: sessionId,
        signReqs: signReqs,
      );

      return Result.success(result);
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<List<PostSignReqEntity>>> postSignWithCert({
    required List<SignRequestPetitionRemoteEntity> signedReqs,
  }) async {
    String sessionId = await _getSessionId() ?? '';
    if (sessionId.isEmpty) {
      const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      final result = await _signRemoteDataSource.postSignWithCert(
        sessionId: sessionId,
        signedReqs: signedReqs,
      );

      return Result.success(result);
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<PreSignClaveEntity>> preSignWithClave({
    required List<String> requestIds,
  }) async {
    String sessionId = await _getSessionId() ?? '';
    if (sessionId.isEmpty) {
      const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      final result = await _signRemoteDataSource.preSignWithClave(
        sessionId: sessionId,
        requestIds: requestIds,
      );

      return Result.success(result);
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<PostSignClaveEntity>> postSignWithClave() async {
    String sessionId = await _getSessionId() ?? '';
    if (sessionId.isEmpty) {
      const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      final result = await _signRemoteDataSource.postSignWithClave(
        sessionId: sessionId,
      );

      return Result.success(result);
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<SignedRequest>> signWithCert({
    required PreSignReqEntity preSignedRequest,
  }) async {
    try {
      List<SignedDocument> signedDocs =
          await Stream.fromIterable(preSignedRequest.signDocs)
              .asyncMap((doc) async {
        String algo = doc.signAlgo.replaceAll('-', '');
        PfSignAlgorithm signAlgo =
            PfSignAlgorithm.fromString('$algo${SignDocument.rsaSuffix}');
        Uint8List decodedPreSign = base64Decode(doc.preSignContent);
        final signedData = await _certificateHandlerLocalDataSourceContract
            .signWithDefaultCertificate(
          decodedPreSign,
          signAlgo,
        );

        return SignedDocument(
          id: doc.id,
          signFrmt: doc.signFrmt,
          signAlgo: doc.signAlgo,
          params: doc.params,
          cop: doc.signOp,
          needCnf: doc.needPre,
          signData: SignData(
            id: doc.id,
            signResultBase64: base64Encode(signedData),
            preSignContent: doc.preSignContent,
            needPre: doc.needPre,
            needData: doc.needData,
            preSignEncoding: doc.preSignEncoding,
            signBase: doc.signBase,
            time: doc.time,
            pid: doc.pid,
          ),
        );
      }).toList();

      return Result.success(SignedRequest(
        id: preSignedRequest.requestId,
        status: preSignedRequest.status,
        signedDocuments: signedDocs,
      ));
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<AuthMethod?> getAuthMethod() async {
    return parseAuthMethodFromString(
      await _authLocalDataSource.getLastAuthMethod(),
    );
  }

  Future<String?> _getSessionId() {
    return _authLocalDataSource.retrieveSessionId();
  }
}
