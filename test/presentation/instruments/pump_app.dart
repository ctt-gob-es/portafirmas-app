import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/presentation/top_blocs/language_bloc/language_bloc.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    Function(BuildContext appContext)? onGetContext,
    List<BlocProvider> providers = const [],
    GoRouter? router,
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: [
          if (router == null)
            BlocProvider(create: (context) => LanguagesBloc()),
          ...providers,
        ],
        child: router != null
            ? InheritedGoRouter(
                goRouter: router,
                child: MaterialApp(
                  theme: AFTheme.getTheme(),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('es', ''),
                  ],
                  locale: const Locale('es', ''),
                  home: Builder(builder: (context) {
                    onGetContext?.call(context);

                    return child;
                  }),
                ),
              )
            : BlocBuilder<LanguagesBloc, LanguageBlocState>(
                builder: (context, state) {
                  return MaterialApp(
                    theme: AFTheme.getTheme(),
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('es', ''),
                    ],
                    locale: state.locale,
                    home: Builder(builder: (context) {
                      onGetContext?.call(context);

                      return child;
                    }),
                  );
                },
              ),
      ),
    );
  }
}
