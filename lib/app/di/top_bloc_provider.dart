
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portafirmas_app/domain/repository_contracts/app_version_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/bloc/document_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/onboarding/bloc/bloc/onboarding_bloc.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/top_blocs/language_bloc/language_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';

class TopBlocProviders extends StatelessWidget {
  final Widget child;
  final _getIt = GetIt.instance;

  TopBlocProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _getIt<ProfileBloc>()),
        BlocProvider(create: (context) => _getIt<LanguagesBloc>()),
        BlocProvider(
          create: (_) => _getIt<SplashBloc>(),
        ),
        BlocProvider(create: (_) => _getIt<PushBloc>()),
        BlocProvider(
          create: (_) => _getIt<OnBoardingBloc>(),
        ),
        BlocProvider(create: (context) => _getIt<AuthBloc>()),
        BlocProvider(create: (context) => _getIt<DetailRequestBloc>()),
        BlocProvider(create: (context) => _getIt<ValidationScreenBloc>()),
        BlocProvider(create: (context) => _getIt<UsersSearchBloc>()),
        BlocProvider(
          create: (context) =>
              _getIt<AppFilterBloc>()..add(const AppFilterEvent.getAppList()),
        ),
        BlocProvider(create: (context) => _getIt<RequestsBloc>()),
        BlocProvider(
          create: (context) => _getIt<SelectServerBloc>()
            ..add(const SelectServerEvent.loadServers()),
        ),
        BlocProvider(create: (context) => _getIt<ProfileBloc>()),
        BlocProvider(create: (_) => _getIt<DocumentBloc>()),
        BlocProvider(create: (context) => _getIt<AuthorizationScreenBloc>()),
        BlocProvider(create: (context) => _getIt<SignBloc>()),
        BlocProvider(create: (context) => _getIt<CertificatesHandleBloc>()),
        BlocProvider(create: (context) => _getIt<MultiSelectionRequestBloc>()),
        BlocProvider(
          create: (_) => AppVersionBloc(
            repository: _getIt<AppVersionRepositoryContract>(),
          )..add(AppVersionEvent.checkAppVersion()),
        ),
      ],
      child: child,
    );
  }
}
