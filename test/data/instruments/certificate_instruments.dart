import 'dart:typed_data';

import 'package:firma_portafirmas/models/enum_pf_key_usage.dart';
import 'package:firma_portafirmas/models/pf_certificate_info.dart';
import 'package:portafirmas_app/data/models/certificate_local_entity.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/models/certificate_usages_enum.dart';

PfCertificateInfo givenPfCertificateInfo() => PfCertificateInfo(
      serialNumber: 'serialNumber',
      alias: 'alias',
      holderName: 'holderName',
      emitterName: 'emitterName',
      expirationDate: DateTime(2030, 01, 01),
      usages: PfKeyUsage.values,
      certEncoded: Uint8List(0),
    );

CertificateLocalEntity givenCertificateLocalEntity() => CertificateLocalEntity(
      serialNumber: 'serialNumber',
      alias: 'alias',
      holderName: 'holderName',
      emitterName: 'emitterName',
      expirationDate: DateTime(2030, 01, 01),
      usages: CertificateUsageLocalEntity.values,
      certEncoded: Uint8List(0),
    );

CertificateEntity givenCertificateEntity() => CertificateEntity(
      serialNumber: 'serialNumber',
      alias: 'alias',
      holderName: 'holderName',
      emitterName: 'emitterName',
      expirationDate: DateTime(2030, 01, 01),
      usages: CertificateUsageEnum.values,
    );

List<CertificateEntity> givenListCertificateEntity() => [
      givenCertificateEntity(),
      CertificateEntity(
        serialNumber: 'serialNumber2',
        alias: 'alias2',
        holderName: 'holderName2',
        emitterName: 'emitterName2',
        expirationDate: DateTime(2032, 01, 01),
        usages: CertificateUsageEnum.values,
      ),
    ];
