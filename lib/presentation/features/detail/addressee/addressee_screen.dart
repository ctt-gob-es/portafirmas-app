
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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/presentation/features/detail/model/request_type.dart';
import 'package:portafirmas_app/presentation/widget/scaffold_base.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/sign_addressee.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';

class AddresseeScreen extends StatelessWidget {
  const AddresseeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final content = context.watch<DetailRequestBloc>().state.loadContent;

    return content != null
        ? ScaffoldBase(
            title: context.localizations.generic_addressee,
            body: Container(
              padding: const EdgeInsets.only(
                left: Spacing.space5,
                top: Spacing.space8,
              ),
              child: ListView(
                children: [
                  AFTitle(
                    brightness: AFThemeBrightness.light,
                    title: context.localizations.requestTypeSignHeader(
                      content.signLinesType ??
                          context.localizations.addressee_parallel_header,
                    ),
                    size: AFTitleSize.l,
                  ),
                  const SizedBox(height: 20),
                  AFTitle(
                    brightness: AFThemeBrightness.light,
                    title: '',
                    subTitle: context.localizations.requestTypeSignTitle(
                      content.signLinesType ??
                          context.localizations.addressee_parallel_header,
                    ),
                    size: AFTitleSize.s,
                    isInverse: true,
                  ),
                  getSignatureType(
                            content.signLinesType ??
                                context.localizations.addressee_parallel_header,
                          ) ==
                          SignatureType.fall
                      ? Semantics(
                          explicitChildNodes: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 25,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            AFTheme.of(context).colors.titles,
                                        boxShadow: AFTheme.of(context)
                                            .shadows
                                            .shadowsSM,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const SizedBox(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: AFTitle(
                                        brightness: AFThemeBrightness.light,
                                        title: content.from,
                                        semanticTitle: content.from,
                                        subTitle: context
                                            .localizations.generic_applicant,
                                        semanticSubTitle: context
                                            .localizations.generic_applicant,
                                        isInverse: true,
                                        size: AFTitleSize.s,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...?content.signLines?.map(
                                (a) => Semantics(
                                  explicitChildNodes: true,
                                  child: AFStepsInfo(
                                    itemList: [
                                      ...a.signName.map(
                                        (e) => AFStep(
                                          title: e.signContent,
                                          description: a.type == null
                                              ? context
                                                  .localizations.generic_sign
                                              : context
                                                  .localizations.approval_text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Semantics(
                          explicitChildNodes: true,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    Assets.iconUser,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AFTitle(
                                      brightness: AFThemeBrightness.light,
                                      title: content.from,
                                      semanticTitle: content.from,
                                      subTitle: context
                                          .localizations.generic_applicant,
                                      isInverse: true,
                                      size: AFTitleSize.s,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ...?content.signLines?.map((e) => SignAddressee(
                                    content: e.signName,
                                    type: e.type == null
                                        ? context.localizations.generic_sign
                                        : context.localizations.approval_text,
                                  )),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
