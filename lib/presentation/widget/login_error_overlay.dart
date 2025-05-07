/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class LoginErrorOverlay extends StatelessWidget {
  final RepositoryError error;
  const LoginErrorOverlay({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      mainButtonFunction: () => context.pop(),
      mainButtonText: context.localizations.general_understood,
      iconPath: mapIcon(error),
      header: mapHeader(error, context),
      description: mapDescription(error, context),
      hideTopBadge: true,
      isReverse: false,
    );
  }

  String mapIcon(RepositoryError error) {
    if (error == const RepositoryError.expiredCertificate() ||
        error == const RepositoryError.invalidCertificate() ||
        error == const RepositoryError.noUserException() ||
        error == const RepositoryError.authorizationPermissionError() ||
        error == const RepositoryError.signWrongCertificate()) {
      return Assets.iconUserX;
    }

    return error == const RepositoryError.revokedCertificate()
        ? Assets.iconAlertCircle
        : Assets.iconXCircle;
  }

  //TODO (TEAM): modify the locations with the correct title
  String mapHeader(RepositoryError error, BuildContext context) {
    if (error == const RepositoryError.invalidCertificate()) {
      return context.localizations.cert_not_valid;
    } else if (error == const RepositoryError.noUserException()) {
      return context.localizations.cert_not_valid;
    } else if (error == const RepositoryError.expiredCertificate()) {
      return context.localizations.cert_not_valid_expired;
    } else if (error == const RepositoryError.revokedCertificate()) {
      return context.localizations.cert_not_valid_revoked;
    } else if (error == const RepositoryError.authorizationPermissionError()) {
      return context.localizations.cert_not_valid_user_no_permission;
    } else if (error == const RepositoryError.signWrongCertificate()) {
      return context.localizations.something_went_wrong_modal_title;
    } else {
      return context.localizations.error_login_cert_title;
    }
  }

  //TODO (TEAM): modify the locations with the correct descriptions
  String mapDescription(RepositoryError error, BuildContext context) {
    if (error == const RepositoryError.invalidCertificate()) {
      return context.localizations.cert_not_valid_description;
    } else if (error == const RepositoryError.noUserException()) {
      return context.localizations.cert_not_valid_description;
    } else if (error == const RepositoryError.expiredCertificate()) {
      return context.localizations.cert_not_valid_description_expired;
    } else if (error == const RepositoryError.revokedCertificate()) {
      return context.localizations.cert_not_valid_description_revoked;
    } else if (error == const RepositoryError.signWrongCertificate()) {
      return context.localizations.server_internal_error_description;
    } else if (error == const RepositoryError.authorizationPermissionError()) {
      return context
          .localizations.cert_not_valid_description_user_no_permission;
    } else {
      return context.localizations.error_login_cert_subtitle;
    }
  }
}
