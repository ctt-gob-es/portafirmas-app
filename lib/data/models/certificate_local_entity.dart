
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:typed_data';

import 'package:firma_portafirmas/models/enum_pf_key_usage.dart';
import 'package:firma_portafirmas/models/pf_certificate_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/models/certificate_usages_enum.dart';

part 'certificate_local_entity.freezed.dart';

enum CertificateUsageLocalEntity { sign, authentication, encrypt }

List<CertificateUsageLocalEntity> getUsages(List<PfKeyUsage> usages) {
  final List<CertificateUsageLocalEntity> result = [];
  for (final usage in usages) {
    switch (usage) {
      case PfKeyUsage.sign:
        result.add(CertificateUsageLocalEntity.sign);
        break;
      case PfKeyUsage.authentication:
        result.add(CertificateUsageLocalEntity.authentication);
        break;
      case PfKeyUsage.encrypt:
        result.add(CertificateUsageLocalEntity.encrypt);
        break;
    }
  }

  return result;
}

@freezed
class CertificateLocalEntity with _$CertificateLocalEntity {
  const factory CertificateLocalEntity({
    required String serialNumber,
    required String? alias,
    required String holderName,
    required String emitterName,
    required DateTime expirationDate,
    required List<CertificateUsageLocalEntity> usages,
    required Uint8List certEncoded,
  }) = _CertificateLocalEntity;

  factory CertificateLocalEntity.fromPfCertificateInfo(
    PfCertificateInfo cert,
  ) =>
      CertificateLocalEntity(
        serialNumber: cert.serialNumber,
        alias: cert.alias,
        usages: getUsages(cert.usages),
        holderName: cert.holderName,
        emitterName: cert.emitterName,
        expirationDate: cert.expirationDate,
        certEncoded: cert.certEncoded,
      );
}

extension CertificateLocalEntityExtension on CertificateLocalEntity {
  List<CertificateUsageEnum> _toCertificateUsagesEnumList() {
    final List<CertificateUsageEnum> result = [];
    for (final usage in usages) {
      switch (usage) {
        case CertificateUsageLocalEntity.sign:
          result.add(CertificateUsageEnum.sign);
          break;
        case CertificateUsageLocalEntity.authentication:
          result.add(CertificateUsageEnum.authentication);
          break;
        case CertificateUsageLocalEntity.encrypt:
          result.add(CertificateUsageEnum.encrypt);
          break;
      }
    }

    return result;
  }

  CertificateEntity toCertificateEntity() => CertificateEntity(
        serialNumber: serialNumber,
        alias: alias,
        holderName: holderName,
        emitterName: emitterName,
        usages: _toCertificateUsagesEnumList(),
        expirationDate: expirationDate,
      );
}
