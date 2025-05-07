
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
import 'package:portafirmas_app/presentation/features/onboarding/bloc/bloc/onboarding_bloc.dart';
import 'package:portafirmas_app/presentation/features/onboarding/widgets/bottom_onboarding_buttons.dart';
import 'package:portafirmas_app/presentation/features/onboarding/widgets/onboarding_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    allowImplicitScrolling: true,
                    onPageChanged: (i) => context.read<OnBoardingBloc>().add(
                          OnBoardingEvent.updatePage(newPage: i),
                        ),
                    children: [
                      OnBoardingPage(
                        image: Assets.iconOnboarding1,
                        title: context.localizations.onboarding_1_title,
                        description:
                            context.localizations.onboarding_1_subtitle,
                      ),
                      OnBoardingPage(
                        image: Assets.iconOnboarding2,
                        title: context.localizations.onboarding_2_title,
                        description:
                            context.localizations.onboarding_2_subtitle,
                      ),
                      OnBoardingPage(
                        image: Assets.iconOnboarding3,
                        title: context.localizations.onboarding_3_title,
                        description:
                            context.localizations.onboarding_3_subtitle,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AFDots(
                      number: 3,
                      position: state.currentPosition.toDouble(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomOnBoardingButtons(
            nextBtnText: state.isLastPage()
                ? context.localizations.end_msg
                : context.localizations.next_msg,
            onTapSkip: () => goAccess(),
            onTapNext: () => state.isLastPage()
                ? goAccess()
                : nextPage(state.currentPosition + 1),
            isLastPage: state.isLastPage(),
          ),
        );
      },
    );
  }

  void nextPage(int nextPage) {
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void goAccess() {
    context.read<OnBoardingBloc>().add(
          const OnBoardingEvent.setOnBoardingFinished(),
        );
    context.go(RoutePath.accessScreen);
  }
}
