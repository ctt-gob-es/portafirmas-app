
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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/server_card.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';

class SelectServerFirstTimeScreen extends StatelessWidget {
  final Function() onAddNewServer;
  final Function() onContinue;
  final Function(ServerEntity server) onSelectServer;
  final int selectedServerIndex;
  final List<ServerEntity> servers;
  final bool isFixed;

  const SelectServerFirstTimeScreen({
    super.key,
    required this.onAddNewServer,
    required this.onContinue,
    required this.onSelectServer,
    required this.selectedServerIndex,
    required this.servers,
    required this.isFixed,
  });

  @override
  Widget build(BuildContext context) {
    const allPadding = EdgeInsets.symmetric(horizontal: Spacing.space4);
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      appBar: AFTopSectionBar.action(
        themeComponent: AFThemeComponent.medium,
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
                  CustomTitleSubtitleBox(
                    title: context.localizations.select_server_title,
                    subtitle: context.localizations.select_server_subtitle,
                    titleSize: AFTitleSize.l,
                  ),
                  const SizedBox(
                    height: Spacing.space8,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: servers.length,
              (context, index) {
                final item = servers[index];
                final isSelected = item.databaseIndex == selectedServerIndex;

                return Padding(
                  padding: allPadding,
                  child: Column(
                    children: [
                      ServerCard(
                        server: item,
                        isSelected: isSelected,
                        onTap: () => onSelectServer(item),
                      ),
                      const SizedBox(
                        height: Spacing.space4,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (!servers.any((element) => element.isFromEmm))
          SliverToBoxAdapter(
            child: Padding(
              padding: allPadding,
              child: Column(
                children: [
                  CustomTitleSubtitleBox(
                    title: context.localizations.select_server_add_server_title,
                    subtitle:
                        context.localizations.select_server_add_server_sub,
                    titleSize: AFTitleSize.s,
                  ),
                  const SizedBox(
                    height: Spacing.space6,
                  ),
                  ExpandedButton(
                    text: context.localizations.select_server_add_server,
                    isTertiary: true,
                    onTap: onAddNewServer,
                  ),
                  const SizedBox(
                    height: Spacing.space32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        top: false,
        child: Container(
          color: AFTheme.of(context).colors.primaryWhite,
          child: Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: bottomPadding + 16,
            ),
            child: ExpandedButton(
              text: context.localizations.general_continue,
              onTap: onContinue,
            ),
          ),
        ),
      ),
    );
  }
}
