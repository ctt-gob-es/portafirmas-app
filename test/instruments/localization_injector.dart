import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsInj extends StatelessWidget {
  final Widget child;
  const LocalizationsInj({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: child,
      navigatorKey: GlobalKey<NavigatorState>(),
      theme: AFTheme.getTheme(),
    );
  }
}
