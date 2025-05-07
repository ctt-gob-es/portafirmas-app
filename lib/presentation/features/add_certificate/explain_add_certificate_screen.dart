
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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/widgets/explain_add_certificate_page.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class ExplainAddCertificateScreen extends StatefulWidget {
  const ExplainAddCertificateScreen({
    super.key,
  });

  @override
  State<ExplainAddCertificateScreen> createState() =>
      _ExplainAddCertificateScreenState();
}

class _ExplainAddCertificateScreenState
    extends State<ExplainAddCertificateScreen> {
  double _actualPosition = 0;

  final PageController _pageController = PageController();

  bool get isLastPage => _actualPosition >= 2;

  @override
  void initState() {
    _pageController.addListener(listenerPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(listenerPage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCertificateBloc, AddCertificateState>(
      listener: (context, state) {
        state.screenStatus.whenOrNull(
          success: () => context.go(RoutePath.addFirstCertificateSuccess),
          error: (_) => context.go(RoutePath.addFirstCertificateError),
        );
      },
      builder: (context, state) {
        return ScreenWithLoader(
          loading: state.screenStatus.isLoading(),
          child: Scaffold(
            appBar: AFTopSectionBar.section(
              themeComponent: AFThemeComponent.medium,
            ),
            backgroundColor: const Color(0xFFFFFFFF),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    allowImplicitScrolling: true,
                    children: [
                      ExplainAddCertificatePage(
                        animation: Assets.onboardingAnimation1,
                        title: context
                            .localizations.add_certificate_explain_1_title,
                        description: context
                            .localizations.add_certificate_explain_1_subtitle,
                      ),
                      ExplainAddCertificatePage(
                        animation: Assets.onboardingAnimation2,
                        title: context
                            .localizations.add_certificate_explain_2_title,
                        description: context
                            .localizations.add_certificate_explain_2_subtitle,
                      ),
                      ExplainAddCertificatePage(
                        animation: Assets.onboardingAnimation3,
                        title: context
                            .localizations.add_certificate_explain_3_title,
                        description: context
                            .localizations.add_certificate_explain_3_subtitle,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AFDots(
                      number: 3,
                      position: _actualPosition,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.space4,
                    right: Spacing.space4,
                    top: Spacing.space1,
                    bottom: Spacing.space10,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: Spacing.space3,
                        ),
                        if (isLastPage) ...[
                          ExpandedButton(
                            size: AFButtonSize.l,
                            text: context.localizations.add_certificate,
                            onTap: () {
                              context.read<AddCertificateBloc>().add(
                                    AddCertificateEvent.addCertificate(
                                      context: context,
                                    ),
                                  );
                            },
                          ),
                        ] else ...[
                          ExpandedButton(
                            size: AFButtonSize.l,
                            text: context.localizations.general_continue,
                            onTap: () => nextPage(_actualPosition.toInt() + 1),
                          ),
                        ],
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void listenerPage() {
    setState(() {
      _actualPosition = _pageController.page ?? 0;
    });
  }

  void nextPage(int nextPage) {
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
