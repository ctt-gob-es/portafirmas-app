import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class ClaveUnauthorizeServerErrorOverlay extends StatelessWidget {
  const ClaveUnauthorizeServerErrorOverlay({
    super.key,
    required this.claveErrorType,
  });

  final ClaveErrorType claveErrorType;

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      mainButtonFunction: () => Navigator.pop(context),
      mainButtonText: context.localizations.general_understood,
      iconPath: Assets.iconUserX,
      header: _getTitle(context),
      // TODO(TEAM): check label in figma
      description: _getDescription(context),
      hideTopBadge: true,
      isReverse: false,
    );
  }

  String _getTitle(BuildContext context) {
    switch (claveErrorType) {
      case ClaveErrorType.unauthorized:
        return context.localizations.clave_sign_in_unknown_user_title;
      case ClaveErrorType.expired:
        return context.localizations.clave_not_valid_expired;
      case ClaveErrorType.revoked:
        return context.localizations.clave_not_valid_revoked;
      case ClaveErrorType.serviceValidationError:
        return context
            .localizations.clave_sign_in_service_validation_error_title;
      case ClaveErrorType.noUserException:
        return context.localizations.no_user_exception_title;
      case ClaveErrorType.unknown:
        return context.localizations.something_went_wrong_modal_title;
    }
  }

  String _getDescription(BuildContext context) {
    switch (claveErrorType) {
      case ClaveErrorType.unauthorized:
        return context.localizations.clave_sign_in_unknown_user_description;
      case ClaveErrorType.expired:
        return context.localizations.clave_sign_in_expired_description;
      case ClaveErrorType.revoked:
        return context.localizations.clave_sign_in_revoked_description;
      case ClaveErrorType.serviceValidationError:
        return context
            .localizations.clave_sign_in_service_validation_error_description;
      case ClaveErrorType.noUserException:
        return context.localizations.no_user_exception_description;
      case ClaveErrorType.unknown:
        return context.localizations.clave_sign_in_generic_error_description;
    }
  }
}
