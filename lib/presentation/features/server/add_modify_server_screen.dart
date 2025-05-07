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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/utils/validators.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/add_overlay_error.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/add_overlay_success.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/delete_overlay_success.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

class AddModifyServerScreen extends StatefulWidget {
  final ServerEntity? initialServer;
  const AddModifyServerScreen({Key? key, this.initialServer}) : super(key: key);

  @override
  State<AddModifyServerScreen> createState() {
    return _AddModifyServerScreenState();
  }
}

class _AddModifyServerScreenState extends State<AddModifyServerScreen> {
  String aliasText = '';
  String urlText = '';

  bool get isNewServer => widget.initialServer == null;

  @override
  void initState() {
    aliasText = widget.initialServer?.alias ?? '';
    urlText = widget.initialServer?.url ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectServerBloc, SelectServerState>(
      listener: (context, state) {
        state.serversDataStatus.whenOrNull(
          error: (_) => _showErrorOverlay(),
          success: () {
            if (isNewServer) {
              _showSuccessOverlay();
            } else {
              context.pop();
              _modalEditServer(context);
            }
          },
        );
      },
      builder: (context, state) {
        return ScreenWithLoader(
          loading: state.serversDataStatus.isLoading(),
          child: Scaffold(
            backgroundColor: AFTheme.of(context).colors.primaryWhite,
            appBar: AFTopSectionBar.section(
              themeComponent: AFThemeComponent.medium,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.space4),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitleSubtitleBox(
                          title: isNewServer
                              ? context.localizations.add_server_title
                              : context.localizations.edit_server_title,
                          subtitle: isNewServer
                              ? context.localizations.add_server_sub
                              : widget.initialServer?.alias,
                          titleSize: AFTitleSize.l,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Spacing.space8,
                            bottom: Spacing.space4,
                          ),
                          child: AFTextInput(
                            maxLines: 1,
                            initialValue:
                                widget.initialServer?.alias ?? aliasText,
                            onChanged: (newValue) => setState(() {
                              aliasText = newValue;
                            }),
                            labelText: context
                                .localizations.add_server_textfield_1_label,
                          ),
                        ),
                        AFTextInput(
                          maxLines: 1,
                          initialValue: urlText,
                          onChanged: (newValue) => setState(() {
                            urlText = newValue.trim();
                          }),
                          validation: (value) {
                            return !checkURlServer(value.trim())
                                ? context.localizations
                                    .add_server_server_url_format_error
                                : null;
                          },
                          labelText:
                              context.localizations.add_server_server_url,
                        ),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isNewServer) ...[
                          const SizedBox(
                            height: Spacing.space3,
                          ),
                          ClearButton(
                            text: context.localizations.edit_server_delete,
                            onTap: () => _showDeleteModal(),
                            size: AFButtonSize.m,
                          ),
                          const SizedBox(
                            height: Spacing.space6,
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: ExpandedButton(
                            enabled:
                                aliasText.isNotEmpty && urlText.length > 15,
                            text: context.localizations.add_server_save_btn,
                            onTap: _onTapAddButton,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapAddButton() {
    FocusScope.of(context).unfocus();

    if (isNewServer) {
      context.read<SelectServerBloc>().add(
            SelectServerEvent.addServer(
              alias: aliasText,
              url: urlText,
            ),
          );
    } else {
      context.read<SelectServerBloc>().add(
            SelectServerEvent.updateServer(
              dbIndex: widget.initialServer?.databaseIndex ?? -1,
              alias: aliasText,
              url: urlText,
            ),
          );
    }
  }

  void _showErrorOverlay() {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => AddOverlayError(
        serverName: aliasText,
        onRetryTap: _onTapAddButton,
      ),
    );
  }

  void _showDeleteModal() async {
    await showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => DeleteOverlaySuccess(
        onDeleteTap: () {
          context.pop();
          context.read<SelectServerBloc>().add(
                SelectServerEvent.deleteServer(
                  widget.initialServer?.databaseIndex ?? -1,
                ),
              );
        },
      ),
    ).whenComplete(() {
      if (!mounted) return;
      context.pop();
      _modalDeleteServer(context);
    });
  }

  void _modalDeleteServer(BuildContext context) {
    return showToast(
      context: context,
      onToastHide: () => DoNothingAction(),
      positionBuilder: (child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: -10,
          child: child,
        );
      },
      builder: (context, _) {
        return AFToast.dark(
          text:
              '${context.localizations.delete_server_notification} $aliasText',
        );
      },
    );
  }

  void _modalEditServer(BuildContext context) {
    return showToast(
      context: context,
      onToastHide: () => DoNothingAction(),
      positionBuilder: (child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: -10,
          child: child,
        );
      },
      builder: (context, _) {
        return AFToast.dark(
          text: context.localizations.servers_notification_edit,
        );
      },
    );
  }

  Future<void> _showSuccessOverlay() async {
    await showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => AddOverlaySuccess(serverName: aliasText),
    ).whenComplete(() {
      if (!mounted) return;
      context.pop();
    });
  }
}
