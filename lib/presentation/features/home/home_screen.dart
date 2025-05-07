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
import 'package:biometric/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/utils/logout.dart';
import 'package:portafirmas_app/data/repositories/models/user_role.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/select_profile/profiles_error_component.dart';
import 'package:portafirmas_app/presentation/features/home/select_profile/select_profile_section.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';

class HomeScreen extends StatefulWidget {
  final bool isChangeProfileScreen;
  final bool biometricsTest;
  const HomeScreen({
    super.key,
    required this.isChangeProfileScreen,
    this.biometricsTest = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserRole? initialProfile;
  late BiometricAuth _biometricInstance;

  @override
  void initState() {
    ProfileBloc bloc = context.read<ProfileBloc>();
    AuthorizationScreenBloc blocAuth = context.read<AuthorizationScreenBloc>();
    bloc.add(
      const ProfileEvent.getProfileList(),
    );
    blocAuth.add(
      const AuthorizationScreenEvent.loadAuthorizations(),
    );
    context.read<CertificatesHandleBloc>().add(
          const CertificatesHandleEvent.checkCertificates(),
        );
    initialProfile = bloc.state.selectedProfile;

    if (!widget.biometricsTest) {
      initBiometricListener();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.biometricsTest) {
      _biometricInstance.timeUp.removeListener(biometricListener);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, current) => current.userAuthStatus.isUnidentified(),
      listener: (context, state) {
        context.read<SplashBloc>().add(
              const SplashEvent.unSplashInNMilliseconds(0),
            );
        context.go(RoutePath.accessScreen);
      },
      child: PopScope(
        onPopInvoked: (didPop) => _resetProfileAndGoBack(),
        canPop: false,
        child: OrientationBuilder(
          builder: (context, orientation) => SafeArea(
            top: false,
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (!widget.isChangeProfileScreen &&
                    state.screenStatus.isSuccess() &&
                    state.profiles.isEmpty) {
                  _initializeFiltersAndGoRequests(state);
                }

                if (state.screenStatus.isSessionExpiredError()) {
                  ModalErrorSessionExpired.modalSessionExpired(context);
                }
              },
              builder: (context, state) => Scaffold(
                backgroundColor: AFTheme.of(context).colors.primaryWhite,
                appBar: AFTopSectionBar.section(
                  themeComponent: AFThemeComponent.medium,
                  onBackTap: () => _resetProfileAndGoBack(),
                ),
                body: state.screenStatus.whenOrNull(
                      success: () => SelectProfileSection(
                        profiles: state.profiles,
                        selectedProfile: state.selectedProfile,
                      ),
                      error: (_) => const ProfilesErrorComponent(),
                    ) ??
                    const LoadingComponent(),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ExpandedButton(
                      enabled: state.screenStatus.isLoading() ? false : true,
                      size: AFButtonSize.l,
                      onTap: () => state.screenStatus.isError()
                          ? context.read<ProfileBloc>().add(
                                const ProfileEvent.getProfileList(),
                              )
                          : _initializeFiltersAndGoRequests(state),
                      text: state.screenStatus.isError()
                          ? context.localizations.general_retry
                          : context.localizations.general_continue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initBiometricListener() {
    _biometricInstance = BiometricAuth();
    _biometricInstance.reInit();
    _biometricInstance.updateCurrentTime(30);
    _biometricInstance.timeUp.addListener(biometricListener);
  }

  void biometricListener() async {
    if (_biometricInstance.timeUp.value) {
      await ModalErrorSessionExpired.modalSessionExpired(context);
    }
  }

  void _resetProfileAndGoBack() {
    context
        .read<ProfileBloc>()
        .add(ProfileEvent.profileSelected(initialProfile?.dni));
    if (widget.isChangeProfileScreen) {
      context.pop();
    } else {
      context.logout(deleteLastAuthMethod: true);
    }
  }

  void _initializeFiltersAndGoRequests(ProfileState state) {
    if (state.selectedProfile != initialProfile ||
        !widget.isChangeProfileScreen) {
      //selected profile has changed

      RequestsBloc bloc = context.read<RequestsBloc>();
      bloc
        ..add(const RequestsEvent.resetState())
        ..add(
          RequestsEvent.updateFilter(
            newFilters: state.isValidator()
                ? RequestFilters.initialForValidators()
                : RequestFilters.initial(),
            isSigner: (state.selectedProfile == null),
            dniValidatorFilter: state.selectedProfile?.dni,
            checkedValidators: false,
          ),
        );
    }
    widget.isChangeProfileScreen
        ? context.pop()
        : context.go(
            RoutePath.requestsScreen,
          );
  }
}
