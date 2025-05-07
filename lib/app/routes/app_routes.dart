
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/initial_access/access_screen.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/cert_added_error_screen.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/cert_added_success_screen.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificate_server_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/annexes_screen.dart';
import 'package:portafirmas_app/presentation/features/filters/filters_screen_provider.dart';
import 'package:portafirmas_app/presentation/features/filters/models/filter_init_data.dart';
import 'package:portafirmas_app/presentation/features/home/home_screen.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/requests_screen_provider.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/explain_add_certificate_screen_provider.dart';
import 'package:portafirmas_app/presentation/features/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/add_new_authorized_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/authorization_details_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/authorization_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/language_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/settings_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/validation_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/validator_search_screen.dart';
import 'package:portafirmas_app/presentation/features/authentication/authentication_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/addressee/addressee_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/detail_request_screen.dart';
import 'package:portafirmas_app/presentation/features/sign/sign_with_clave_screen.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_controller.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/presentation/features/server/add_modify_server_screen.dart';
import 'package:portafirmas_app/presentation/features/server/select_change_server_screen.dart';

import 'package:portafirmas_app/presentation/features/certificates/certificates_warning_screen_android_provider.dart';
import 'package:portafirmas_app/presentation/features/change_certificate_ios/change_certificate_screen_provider.dart';

GoRoute serverChangeFlow = GoRoute(
  path: 'servers',
  builder: (context, state) => const SelectChangeServerScreen.change(),
  routes: [
    GoRoute(
      path: 'edit',
      builder: (context, state) => AddModifyServerScreen(
        initialServer: state.extra as ServerEntity?,
      ),
    ),
  ],
);

List<GoRoute> appRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashController(),
  ),
  GoRoute(
    path: '/onBoarding',
    builder: (context, state) => const OnBoardingScreen(),
  ),
  GoRoute(
    path: '/accessScreen',
    builder: (context, state) => const AccessScreen(),
    routes: [
      GoRoute(
        path: 'selectFirstTimeServer',
        builder: (context, state) => const SelectChangeServerScreen.firstTime(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => AddModifyServerScreen(
              initialServer: state.extra as ServerEntity?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: 'authentication',
        builder: (context, state) => const AuthenticationScreen(),
        routes: [
          GoRoute(
            path: 'explainAddCert',
            builder: (context, state) => ExplainAddCertificateScreenProvider(),
            routes: [
              GoRoute(
                path: 'certAddSuccess',
                builder: (context, state) => const CertAddedSuccessScreen(),
              ),
              GoRoute(
                path: 'certAddError',
                builder: (context, state) => const CertAddedErrorScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'serverCertScreen',
            builder: (context, state) =>
                const CertificateAndServerSelectedScreen(),
            routes: [
              serverChangeFlow,
              GoRoute(
                path: 'certificates',
                builder: (context, state) => ChangeCertificateScreenProvider(),
                routes: [
                  GoRoute(
                    path: 'certAddSuccess',
                    builder: (context, state) => const CertAddedSuccessScreen(),
                  ),
                  GoRoute(
                    path: 'certAddError',
                    builder: (context, state) => const CertAddedErrorScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'certificateWarning',
                builder: (context, state) =>
                    CertificatesWarningScreenAndroidProvider(),
              ),
            ],
          ),
        ],
      ),
      serverChangeFlow,
    ],
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomeScreen(
      isChangeProfileScreen: false,
    ),
    routes: [
      GoRoute(
        path: 'requestsScreen',
        builder: (context, state) => const RequestsScreenProvider(),
        routes: requestsSubScreens,
      ),
    ],
  ),
];

List<GoRoute> requestsSubScreens = [
  GoRoute(
    path: 'signWithClaveScreen',
    builder: (context, state) => SignWithClaveScreen(
      signUrl: state.extra as String,
    ),
  ),
  GoRoute(
    path: 'filtersScreen',
    builder: (context, state) => FiltersScreenProvider(
      filterInitData: state.extra as FilterInitData,
    ),
  ),
  GoRoute(
    path: 'settingsScreen',
    builder: (context, state) => const SettingsScreen(),
    routes: [
      GoRoute(
        path: 'profileScreen',
        builder: (context, state) => const HomeScreen(
          isChangeProfileScreen: true,
        ),
      ),
      GoRoute(
        path: 'validationScreen',
        builder: (context, state) => const ValidationScreen(),
        routes: [
          GoRoute(
            path: 'validationSearchScreen',
            builder: (context, state) => const ValidatorSearchScreen(),
          ),
        ],
      ),
      GoRoute(
        path: 'authorizationScreen',
        builder: (context, state) => const AuthorizationsScreen(),
        routes: [
          GoRoute(
            path: 'addAuthorizedScreen',
            builder: (context, state) => const AddNewAuthorized(),
          ),
          GoRoute(
            path: 'authorizationDetailsScreen',
            builder: (context, state) => const AuthorizationDetailsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: 'languageScreen',
        builder: (context, state) => const LanguageScreen(),
      ),
    ],
  ),
  GoRoute(
    path: 'detailRequestScreen',
    builder: (context, state) => DetailRequestScreen(
      requestStatus: state.extra is RequestStatus
          ? state.extra as RequestStatus
          : RequestStatus.pending,
    ),
    routes: [
      GoRoute(
        path: 'addresseeScreen',
        builder: (context, state) => const AddresseeScreen(),
      ),
      GoRoute(
        path: 'annexesScreen',
        builder: (context, state) => AnnexesScreen(
          requestStatus: state.extra as RequestStatus,
        ),
      ),
      GoRoute(
        path: 'signWithClaveScreen',
        builder: (context, state) => SignWithClaveScreen(
          signUrl: state.extra as String,
        ),
      ),
    ],
  ),
];
