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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

class ModalTemplate extends StatelessWidget {
  final String iconPath;
  final String header;
  final String? description;
  final String? mainButtonText;
  final Function mainButtonFunction;
  final String? secondaryButtonText;
  final Function? secondaryButtonFunction;
  final bool? isFantasma;
  final bool isReverse;
  final String? mainButtonIconRight;
  final String? linkText;
  final Function? onTapLinkText;
  final bool? hideTopBadge;
  final List<Widget>? moreChildrens;
  final Color? overrideIconColor;
  final String? titleSemanticsLabel;

  const ModalTemplate({
    super.key,
    this.description,
    this.mainButtonText,
    required this.mainButtonFunction,
    this.secondaryButtonText,
    this.secondaryButtonFunction,
    required this.iconPath,
    required this.header,
    this.isFantasma,
    this.mainButtonIconRight,
    this.linkText,
    this.onTapLinkText,
    this.hideTopBadge,
    this.moreChildrens,
    this.overrideIconColor,
    this.titleSemanticsLabel,
    required this.isReverse,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget>? moreChilds = moreChildrens;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: Spacing.space4,
          ),
          if (hideTopBadge == null || hideTopBadge == false) ...[
            Container(
              width: 56,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AFTheme.of(context).colors.neutral8,
              ),
            ),
            const SizedBox(
              height: Spacing.space2,
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(Spacing.space1),
            child: DefaultTextStyle(
              style: const TextStyle(),
              child: AFOverlay(
                header: AFOverlayHeaderMessage(
                  iconPath: iconPath,
                  title: header,
                  titleSemanticsLabel: titleSemanticsLabel ?? header,
                  subtitle: linkText != null ? null : description,
                  subtitleSemanticsLabel: linkText != null ? null : description,
                  overrideIconColor: overrideIconColor,
                ),
                content: AFOverlayContent(
                  children: [
                    const SizedBox(height: Spacing.space4),
                    //Overlay description has a link
                    if (linkText != null) ...[
                      Text.rich(
                        TextSpan(
                          text: description,
                          children: [
                            TextSpan(
                              text: linkText,
                              semanticsLabel: titleSemanticsLabel ?? linkText,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  onTapLinkText?.call();
                                },
                            ),
                          ],
                        ),
                        style: AFTheme.of(context).typoOnLight.bodyMd.copyWith(
                              color: AFTheme.of(context).colors.secondaryBlack,
                            ),
                      ),
                      const SizedBox(height: Spacing.space10),
                    ],
                    if (moreChilds != null) ...[
                      const SizedBox(height: Spacing.space2),
                      ...moreChilds.toList(),
                    ],
                    isReverse
                        ? Column(
                            children: [
                              if (mainButtonText != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: isFantasma ?? false
                                      ? AFButton.terciaryPrimary(
                                          sizeButton: AFButtonSize.m,
                                          brightness: AFThemeBrightness.light,
                                          text: mainButtonText ?? '',
                                          semanticsLabel: mainButtonText,
                                          onPressed: () => mainButtonFunction(),
                                          assetIconRight: mainButtonIconRight,
                                        )
                                      : AFButton.secondary(
                                          sizeButton: AFButtonSize.m,
                                          brightness: AFThemeBrightness.light,
                                          text: mainButtonText ?? '',
                                          semanticsLabel: mainButtonText,
                                          onPressed: () => mainButtonFunction(),
                                          assetIconRight: mainButtonIconRight,
                                        ),
                                ),
                                const SizedBox(height: Spacing.space9),
                              ],
                              if (secondaryButtonText != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: AFButton.link(
                                    foregroundColorOverride:
                                        AFTheme.of(context).colors.primary,
                                    brightness: AFThemeBrightness.light,
                                    text: secondaryButtonText ?? '',
                                    onPressed: () =>
                                        secondaryButtonFunction?.call(),
                                  ),
                                ),
                                const SizedBox(height: Spacing.space6),
                              ],
                            ],
                          )
                        : Column(
                            children: [
                              if (secondaryButtonText != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: AFButton.link(
                                    foregroundColorOverride:
                                        AFTheme.of(context).colors.primary,
                                    brightness: AFThemeBrightness.light,
                                    text: secondaryButtonText ?? '',
                                    onPressed: () =>
                                        secondaryButtonFunction?.call(),
                                  ),
                                ),
                                const SizedBox(height: Spacing.space6),
                              ],
                              if (mainButtonText != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: isFantasma ?? false
                                      ? AFButton.terciaryPrimary(
                                          sizeButton: AFButtonSize.m,
                                          brightness: AFThemeBrightness.light,
                                          text: mainButtonText ?? '',
                                          semanticsLabel: mainButtonText,
                                          onPressed: () => mainButtonFunction(),
                                          assetIconRight: mainButtonIconRight,
                                        )
                                      : AFButton.secondary(
                                          sizeButton: AFButtonSize.m,
                                          brightness: AFThemeBrightness.light,
                                          text: mainButtonText ?? '',
                                          semanticsLabel: mainButtonText ==
                                                  context.localizations
                                                      .generic_button_sign
                                              ? context.localizations
                                                  .sign_approve_text
                                              : mainButtonText,
                                          onPressed: () => mainButtonFunction(),
                                          assetIconRight: mainButtonIconRight,
                                        ),
                                ),
                                const SizedBox(height: Spacing.space9),
                              ],
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
