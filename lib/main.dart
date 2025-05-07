/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:af_privacy_policy/af_privacy_policy.dart';
import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:biometric/main.dart';
import 'package:dynatrace/dynatrace.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/di/di.dart' as app_di;
import 'package:portafirmas_app/app/di/top_bloc_provider.dart';
import 'package:portafirmas_app/app/routes/app_routes.dart';
import 'package:portafirmas_app/app/theme/colors.dart';
import 'package:portafirmas_app/data/models/server_local_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/presentation/top_blocs/language_bloc/language_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Dynatrace.initialize();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ServerLocalEntityAdapter());
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  await app_di.initDi(secureStorage: secureStorage);
  if (sharedPreferences.getBool('appAlreadyInstalled') != true) {
    await Future.wait([
      GetIt.instance
          .get<CertificateRepositoryContract>()
          .deleteAllCertificate(),
      secureStorage.deleteAll(),
      sharedPreferences.setBool('appAlreadyInstalled', true),
    ]);
  }
  AFPrivacyPolicy.configure(paramsUrl: AppUrls.privacyPolicyLink);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GoRouter _router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    routes: appRoutes,
    observers: [Dynatrace.navigationObserver()],
  );

  AppLifecycleState? previousState;
  final BiometricAuth _biometricInstance = BiometricAuth();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _biometricInstance.updateCurrentTime(30);

    super.initState();
  }

  /// This methods is added to update the timer of inactivity when the app
  /// comes from background

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _biometricInstance.updateCurrentMaxTime();
        previousState = AppLifecycleState.resumed;
        break;
      case AppLifecycleState.paused:
        _biometricInstance.saveMaxTime();
        previousState = AppLifecycleState.paused;
        break;
      case AppLifecycleState.inactive:
        previousState = AppLifecycleState.inactive;
        break;
      case AppLifecycleState.detached:
        previousState = AppLifecycleState.detached;
        break;
      case AppLifecycleState.hidden:
        previousState = AppLifecycleState.hidden;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBlocProviders(
      child: Listener(
        onPointerDown: (e) => !_biometricInstance.timeUp.value
            ? _biometricInstance.updateCurrentTime(30)
            : DoNothingAction(),
        child: BlocBuilder<LanguagesBloc, LanguageBlocState>(
          builder: (context, state) {
            return MaterialApp.router(
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
              title: AppLiterals.appName,
              theme: AFTheme.getTheme(
                themeData: AFTheme.defaultTheme
                    .copyWith(colors: AppColors.getAppThemeColors()),
              )
                  // ignore: deprecated_member_use
                  .copyWith(useMaterial3: false), //TODO: remove UIKIT edited,

              locale: state.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('es', ''),
                Locale('gl', ''),
                Locale('eu', ''),
                Locale('en', ''),
                Locale('ca', ''),
              ],
            );
          },
        ),
      ),
    );
  }
}
