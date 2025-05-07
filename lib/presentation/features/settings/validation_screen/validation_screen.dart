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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/validator_user_entity.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/validation_error_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/custom_subtitle.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;
    bool refreshScreen = false;

    return BlocConsumer<ValidationScreenBloc, ValidationScreenState>(
      listener: (context, state) {
        if (state.screenStatus.isSessionExpiredError()) {
          ModalErrorSessionExpired.modalSessionExpired(context);
        } else if (state.screenStatus.isError()) {
          showHelpOverlayError(
            context,
            context.localizations.something_went_wrong_modal_title,
            context.localizations.server_internal_error_description,
          );
        }
      },
      builder: (context, state) {
        return state.screenStatus.maybeWhen(
          initial: () {
            if (!refreshScreen) {
              context.read<ValidationScreenBloc>().add(
                    const ValidationScreenEvent.loadUsers(),
                  );
              refreshScreen = true;
            }

            return const SizedBox.shrink();
          },
          loading: () => Scaffold(
            backgroundColor: white,
            body: const Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          error: (error) => const ValidationScreenErrorPage(),
          success: () {
            return Scaffold(
              backgroundColor: white,
              appBar: AFTopSectionBar.section(
                themeComponent: AFThemeComponent.medium,
                title: context.localizations.settings_screen_validators_menu,
                backButtonOverride: AFTopBarActionIcon(
                  isSecondary: false,
                  iconPath: Assets.iconChevronLeft,
                  semanticsLabel: context.localizations.general_back,
                  onTap: () {
                    context.read<ValidationScreenBloc>().add(
                          const ValidationScreenEvent.refreshScreen(),
                        );
                    context.pop();
                  },
                ),
              ),
              body: state.listOfValidatorUsers.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomSubtitleBox(
                                subtitle: context
                                    .localizations.validators_screen_subtitle,
                              ),
                            ],
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.listOfValidatorUsers.length,
                            (context, index) {
                              ValidatorUserEntity validatorUser = state
                                  .listOfValidatorUsers[index].validatorUser;

                              return ListTile(
                                title: Semantics(
                                  label:
                                      '${validatorUser.name}. ${context.localizations.press_twice_delete_validator}',
                                  excludeSemantics: true,
                                  child: AFMenu.normal(
                                    text: validatorUser.name,
                                    isBox: false,
                                    moreLevels: true,
                                    onTap: () => context
                                        .read<ValidationScreenBloc>()
                                        .add((ValidationScreenEvent.removeUser(
                                          validatorUser.id,
                                        ))),
                                    rightIconAsset: Assets.iconTrash,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: SvgPicture.asset(
                              Assets.iconAlertCircle,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AFTitle(
                            brightness: AFThemeBrightness.light,
                            title: context.localizations.empty_validator_text,
                            size: AFTitleSize.l,
                            align: AFTitleAlign.center,
                          ),
                        ],
                      ),
                    ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: AFButton.secondary(
                  onPressed: () {
                    validatorSearchAction(context);
                  },
                  text: context.localizations.add_new_validator_button,
                ),
              ),
            );
          },
          orElse: () {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void validatorSearchAction(BuildContext context) {
    context.read<UsersSearchBloc>().add(const UsersSearchEvent.clearResults());
    context
        .read<ValidationScreenBloc>()
        .add(const ValidationScreenEvent.loadUsers());
    context.go(RoutePath.validationSearchScreen);
  }

  @visibleForTesting
  showHelpOverlayError(
    BuildContext context,
    String header,
    String description,
  ) {
    return showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => ModalTemplate(
        isReverse: false,
        header: header,
        description: description,
        iconPath: Assets.iconXCircle,
        mainButtonText: context.localizations.general_understood,
        mainButtonFunction: () => context.pop(),
      ),
    );
  }
}
