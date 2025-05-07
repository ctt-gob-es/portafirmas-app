
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/models/certificate_local_entity.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';

import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/data/repositories/models/result_check_certificate.dart';

class CertificateRepository implements CertificateRepositoryContract {
  final CertificateHandlerLocalDataSourceContract
      _certificateHandlerLocalDataSourceContract;

  CertificateRepository(
    this._certificateHandlerLocalDataSourceContract,
  );

  @override
  Future<ResultCheckCertificate> checkCertificates() async {
    final selectedCertificate =
        (await _certificateHandlerLocalDataSourceContract
                .getDefaultCertificate())
            ?.toCertificateEntity();

    if (selectedCertificate != null) {
      return ResultCheckCertificate.hasCertificateSelected(
        selectedCertificate,
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return const ResultCheckCertificate.noCertificateSelected();
    } else {
      // Check if user has certificates
      final hasCertificates = await _certificateHandlerLocalDataSourceContract
          .userHasCertificates();

      return hasCertificates
          ? const ResultCheckCertificate.noCertificateSelected()
          : const ResultCheckCertificate.userHasNoCertificatesOnIOS();
    }
  }

  @override
  Future<Result> addCertificate({
    required BuildContext context,
    required Uint8List certificate,
  }) async {
    try {
      await _certificateHandlerLocalDataSourceContract.addCertificate(
        context: context,
        certificate: certificate,
      );

      return const Result.success('');
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result> selectCertificate({
    required BuildContext context,
  }) async {
    try {
      await _certificateHandlerLocalDataSourceContract.selectDefaultCertificate(
        context: context,
      );

      return const Result.success('');
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result> deleteCertificate(CertificateEntity certificateEntity) async {
    try {
      await _certificateHandlerLocalDataSourceContract.deleteCertificate(
        certificateEntity.serialNumber,
      );

      return const Result.success('');
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<List<CertificateEntity>>> getAllCertificates() async {
    try {
      final certs =
          await _certificateHandlerLocalDataSourceContract.getAllCertificates();

      return Result.success(certs.map((e) => e.toCertificateEntity()).toList());
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result> setCertificateDefault(
    CertificateEntity certificateEntity,
  ) async {
    try {
      await _certificateHandlerLocalDataSourceContract.setCertificateDefault(
        certificateEntity.serialNumber,
      );

      return const Result.success('');
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<CertificateEntity?>> getDefaultCertificate() async {
    try {
      final cert = await _certificateHandlerLocalDataSourceContract
          .getDefaultCertificate();

      return Result.success(cert?.toCertificateEntity());
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<CertificateEntity?>> changeDefaultCertificate(
    BuildContext context,
  ) async {
    try {
      final cert = await _certificateHandlerLocalDataSourceContract
          .selectDefaultCertificate(context: context);

      return Result.success(cert?.toCertificateEntity());
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }

  @override
  Future<Result<void>> deleteAllCertificate() async {
    final certs = await getAllCertificates();
    await certs.whenOrNull(
      success: (certs) async {
        for (var cert in certs) {
          await deleteCertificate(cert);
        }
      },
    );

    return const Result.success(null);
  }
}
