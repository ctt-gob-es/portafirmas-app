
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
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/app_version/widgets/new_version_overlay.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_screen.dart';

import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/presentation/features/splash/widgets/required_update_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppVersionBloc, AppVersionState>(
      listener: (context, state) {
        state.whenOrNull(
          recommendedUpdateVersion: (_) =>
              _showRecommendedUpdateOverlay(context),
          requiredUpdateVersion: (_, __) => DoNothingAction(),
          //If no required/recommended version, go to access screen
          upToDateVersion: (_) => _goToAccessScreen(context),
          error: () => _goToAccessScreen(context),
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          requiredUpdateVersion: ((_, minVersion) =>
              RequiredUpdateScreen(version: minVersion)),
          orElse: () => BlocConsumer<SplashBloc, SplashState>(
            listener: (context, state) {
              state.whenOrNull(
                splashed: (welcomeTourIsFinished, _, __) {
                  if (welcomeTourIsFinished) {
                    context.go(RoutePath.accessScreen);
                  } else {
                    context.go(
                      RoutePath.onBoarding,
                    );
                  }
                },
              );
            },
            builder: (context, state) {
              return const SplashScreen();
            },
          ),
        );
      },
    );
  }

  void _goToAccessScreen(BuildContext context) {
    context.read<SplashBloc>().add(
          const SplashEvent.unSplashInNMilliseconds(3000),
        );
  }

  void _showRecommendedUpdateOverlay(BuildContext context) {
    showModalAFOverlay(
      context: context,
      overlayBuilder: (context) => NewVersionOverlay(
        iconPath: Assets.iconRefresh,
        onTapButton: () {
          launchUrl(
            Uri.parse(
              AppUrls.getUrlUpdateApp(
                Theme.of(context).platform == TargetPlatform.android,
              ),
            ),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
    );
  }
}
