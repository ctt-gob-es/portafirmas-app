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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class ListItemSelectableScreen<T> extends StatelessWidget {
  final Function() onAddTap;
  final String screenTitle;

  final String screenSubtitle;

  final List<T> itemList;
  final Widget Function(BuildContext context, T item) itemBuilder;

  final String? guideText;

  final Widget? emptyWidget;
  final String secondaryButtonText;
  final Function() onSecondaryActionTap;
  final bool hideSecondaryAction;

  final String mainButtonText;
  final Function() onMainActionTap;

  final bool isComplete;

  const ListItemSelectableScreen({
    super.key,
    required this.onAddTap,
    required this.screenTitle,
    required this.screenSubtitle,
    required this.itemList,
    required this.itemBuilder,
    required this.secondaryButtonText,
    required this.onSecondaryActionTap,
    required this.hideSecondaryAction,
    required this.mainButtonText,
    required this.onMainActionTap,
    this.emptyWidget,
    this.isComplete = true,
    this.guideText,
  });

  @override
  Widget build(BuildContext context) {
    const allPadding = EdgeInsets.symmetric(horizontal: Spacing.space4);
    final selectedServer = context
        .select((SelectServerBloc cubit) => cubit.state.preSelectedServer);

    return Scaffold(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      appBar: AFTopSectionBar.section(
        backButtonOverride: AFTopBarActionIcon(
          iconPath: Assets.iconX,
          semanticsLabel: context.localizations.close_text,
          onTap: () => context.pop(),
        ),
        themeComponent: AFThemeComponent.medium,
        actions: [
          AFTopBarActionIcon(
            iconPath: Assets.iconPlus,
            semanticsLabel: context.localizations.select_server_add_server,
            onTap: onAddTap,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: allPadding,
              child: Column(
                children: [
                  const SizedBox(
                    height: Spacing.space4,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomTitleSubtitleBox(
                      title: screenTitle,
                      subtitle: screenSubtitle,
                      titleSize: AFTitleSize.l,
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.space4,
                  ),
                ],
              ),
            ),
          ),
          if (itemList.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: itemList.length,
                (context, index) {
                  final item = itemList[index];

                  return Padding(
                    padding:
                        allPadding.add(const EdgeInsets.symmetric(vertical: 8)),
                    child: itemBuilder(context, item),
                  );
                },
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isComplete
                    ? emptyWidget ?? const SizedBox()
                    : const SizedBox(),
              ),
            ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: allPadding,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: Spacing.space3,
                  ),
                  Text(
                    guideText ?? '',
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    height: Spacing.space3,
                  ),
                  if (!hideSecondaryAction && !selectedServer.isFromEmm) ...[
                    ClearButton(
                      text: secondaryButtonText,
                      onTap: onSecondaryActionTap,
                      size: AFButtonSize.m,
                    ),
                    const SizedBox(
                      height: Spacing.space6,
                    ),
                  ],
                  Semantics(
                    hint: context.localizations.press_twice_to_open,
                    child: ExpandedButton(
                      text: mainButtonText,
                      onTap: onMainActionTap,
                    ),
                  ),
                  SizedBox(
                    height:
                        Spacing.space4 + MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
