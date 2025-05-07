
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/document_widget.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/detail_content_header.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';
import 'package:portafirmas_app/domain/models/document_entity.dart';

class SignedDocuments extends StatelessWidget {
  final List<DocumentEntity> docsList;
  const SignedDocuments({Key? key, required this.docsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AFCustomContentHeader(
          brightness: AFThemeBrightness.light,
          rightIcon: SvgPicture.asset(
            Assets.iconCircleInfo,
            excludeFromSemantics: true,
          ),
          title: context.localizations.generic_sign,
          semanticTitle: context.localizations.generic_sign,
          onTap: () => showHelpSignOverlay(context),
        ),
        ...docsList.map(
          (doc) => DocumentWidget(
            doc: doc,
            documentType: DocumentType.signDoc,
          ),
        ),
        AFCustomContentHeader(
          brightness: AFThemeBrightness.light,
          rightIcon: SvgPicture.asset(
            Assets.iconCircleInfo,
            excludeFromSemantics: true,
          ),
          title: context.localizations.generic_informs_sign,
          semanticTitle: context.localizations.generic_informs_sign,
          onTap: () => showHelpInformsSignOverlay(context),
        ),
        ...docsList.map(
          (doc) => DocumentWidget(
            doc: doc,
            documentType: DocumentType.signReport,
          ),
        ),
      ],
    );
  }

  void showHelpSignOverlay(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => ModalTemplate(
        isReverse: false,
        description: context.localizations.info_sign_module,
        mainButtonText: context.localizations.general_understood,
        mainButtonFunction: () => Navigator.pop(context),
        iconPath: Assets.iconCircleInfo,
        header: context.localizations.generic_sign,
      ),
    );
  }

  void showHelpInformsSignOverlay(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => ModalTemplate(
        isReverse: false,
        description: context.localizations.info_generic_informs_module,
        mainButtonText: context.localizations.general_understood,
        mainButtonFunction: () => Navigator.pop(context),
        iconPath: Assets.iconCircleInfo,
        header: context.localizations.generic_informs_sign,
      ),
    );
  }
}
