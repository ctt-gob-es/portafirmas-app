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
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';

class AuthorizationSearchScreen extends StatelessWidget {
  final TextEditingController controller;
  const AuthorizationSearchScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersSearchBloc, UsersSearchState>(
      builder: (ctx, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(bottom: 200),
          child: Column(
            children: [
              Visibility(
                visible: state.numberOfResults > 0,
                replacement: Visibility(
                  visible: controller.text.isNotEmpty &&
                      state.suggestedUsers.every(
                        (user) => !user.name.toLowerCase().contains(
                              controller.text.toLowerCase(),
                            ),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: SvgPicture.asset(
                                Assets.iconAlertCircle,
                              ),
                            ),
                            AFTitle(
                              brightness: AFThemeBrightness.light,
                              title: context.localizations.error_result_text,
                              subTitle:
                                  context.localizations.error_result_text_tip,
                              size: AFTitleSize.l,
                              align: AFTitleAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AFTitle(
                      brightness: AFThemeBrightness.light,
                      title:
                          '${state.numberOfResults} ${context.localizations.result_text}',
                      size: AFTitleSize.s,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    state.numberOfResults > 0 || state.selectedUser != null,
                replacement: const SizedBox.shrink(),
                child: Expanded(
                  child: AFMenuList.selectOne(
                    preSelectedItem: state.selectedUser,
                    elements: state.suggestedUsers,
                    onItemTap: (user) {
                      context
                          .read<UsersSearchBloc>()
                          .add(UsersSearchEvent.selectedUser(user));
                      controller.text = user.name;
                    },
                    itemBuilder: (
                      BuildContext context,
                      UserSearch user,
                      AFThemeBrightness brightness,
                      Function() onTap,
                      bool isSelected,
                    ) {
                      return AFMenu.oneSelect(
                        text: user.name,
                        onTap: onTap,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
