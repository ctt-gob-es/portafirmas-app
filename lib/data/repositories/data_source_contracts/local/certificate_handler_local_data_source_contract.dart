
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

import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:flutter/cupertino.dart';

import 'package:portafirmas_app/data/models/certificate_local_entity.dart';

abstract class CertificateHandlerLocalDataSourceContract {
  Future<CertificateLocalEntity?> getDefaultCertificate();
  Future<Uint8List> signWithDefaultCertificate(
    Uint8List data,
    PfSignAlgorithm signAlgo,
  );

  Future<bool> userHasCertificates();
  Future<void> addCertificate({
    required BuildContext context,
    required Uint8List certificate,
  });

  Future<CertificateLocalEntity?> selectDefaultCertificate({
    required BuildContext context,
  });

  Future<List<CertificateLocalEntity>> getAllCertificates();
  Future<void> setCertificateDefault(String serialNumber);
  Future<void> deleteCertificate(String serialNumber);
}
