/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/overlays/af_overlay_show.dart';
import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/presentation/features/server/change_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/migration_overlay_error.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

enum _ScreenType {
  firstTime,
  change,
}

class SelectChangeServerScreen extends StatefulWidget {
  final _ScreenType _screenType;

  const SelectChangeServerScreen.firstTime({Key? key})
      : _screenType = _ScreenType.firstTime,
        super(key: key);
  const SelectChangeServerScreen.change({Key? key})
      : _screenType = _ScreenType.change,
        super(key: key);

  @override
  State<SelectChangeServerScreen> createState() {
    return _SelectChangeServerScreenState();
  }
}

class _SelectChangeServerScreenState extends State<SelectChangeServerScreen> {
  @override
  void initState() {
    context
        .read<SelectServerBloc>()
        .add(const SelectServerEvent.loadMigratedServers());

    super.initState();
  }

  _ScreenType get _screenType => widget._screenType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectServerBloc, SelectServerState>(
      listener: (context, state) {
        state.defaultServerStatus.whenOrNull(success: () {
          switch (_screenType) {
            case _ScreenType.firstTime:
              if (GoRouter.of(context).location == RoutePath.selectServer) {
                context.go(RoutePath.authentication);

                context
                    .read<SelectServerBloc>()
                    .add(const SelectServerEvent.changeScreen());
              }
              break;
            case _ScreenType.change:
              context.pop();
              break;
          }
        });

        state.serversMigrationDataStatus
            .whenOrNull(error: (_) => _showMigrationErrorOverlay());
      },
      builder: (context, state) {
        return ScreenWithLoader(
          loading: state.serversDataStatus.isLoading() ||
              state.defaultServerStatus.isLoading() ||
              state.serversMigrationDataStatus.isLoading(),
          child: Builder(builder: (context) {
            switch (_screenType) {
              case _ScreenType.firstTime:
                return SelectServerFirstTimeScreen(
                  onAddNewServer: () => _goToServerEdition(context),
                  selectedServerIndex: state.preSelectedServer.databaseIndex,
                  onContinue: () => context
                      .read<SelectServerBloc>()
                      .add(const SelectServerEvent.setSelectedServerDefault()),
                  onSelectServer: (serverToSelect) => context
                      .read<SelectServerBloc>()
                      .add(SelectServerEvent.selectServer(serverToSelect)),
                  servers: state.servers,
                  isFixed: state.preSelectedServer.isFixed,
                );
              case _ScreenType.change:
                return ChangeServerScreen(
                  onAddNewServer: () => _goToServerEdition(context),
                  isSelectedServerDefault: state.preSelectedServer.isDefault,
                  selectedServerIndex: state.preSelectedServer.databaseIndex,
                  onEditSelectedServer: () =>
                      _goToServerEdition(context, state.preSelectedServer),
                  onContinue: () => context
                      .read<SelectServerBloc>()
                      .add(const SelectServerEvent.setSelectedServerDefault()),
                  onSelectServer: (serverToSelect) => context
                      .read<SelectServerBloc>()
                      .add(SelectServerEvent.selectServer(serverToSelect)),
                  servers: state.servers,
                  isFirstTime: _screenType == _ScreenType.firstTime,
                );
            }
          }),
        );
      },
    );
  }

  void _goToServerEdition(BuildContext context, [ServerEntity? serverEntity]) {
    context.go(
      GoRouter.of(context).location + RoutePath.serverEditionPath,
      extra: serverEntity,
    );
  }

  void _showMigrationErrorOverlay() {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => const MigrationOverlayError(),
    );
  }
}
