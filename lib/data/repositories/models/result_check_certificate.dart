
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
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';

part 'result_check_certificate.freezed.dart';

@freezed
class ResultCheckCertificate with _$ResultCheckCertificate {
  /// Factory constructor for representing a failure.
  /// Takes an instance of 'RepositoryError' as a required parameter.
  const factory ResultCheckCertificate.failure({
    required RepositoryError error,
  }) = _Failure;

  /// Factory constructor for representing user has certificate selected
  const factory ResultCheckCertificate.hasCertificateSelected(
    CertificateEntity defaultCertificate,
  ) = _Success;

  /// Factory constructor for representing user has not certificate selected
  const factory ResultCheckCertificate.noCertificateSelected() =
      _NoCertificateSelected;

  /// Factory constructor for representing user has no certificates on ios
  const factory ResultCheckCertificate.userHasNoCertificatesOnIOS() =
      _UserHasNoCertificatesOnIOS;
}
