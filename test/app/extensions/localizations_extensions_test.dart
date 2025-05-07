import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/constants/initial_servers.dart';
import 'package:portafirmas_app/app/extensions/localizations_extensions.dart';
import 'package:portafirmas_app/domain/models/certificate_usages_enum.dart';

main() {
  test(
    'GIVEN initial servers WHEN get server name and subtitle THEN is not empty',
    () async {
      AppLocalizations localizations =
          await AppLocalizations.delegate.load(const Locale('es'));
      for (final server in initialServers) {
        expect(localizations.defaultServerName(server).isNotEmpty, true);
        expect(localizations.defaultServerSubtitle(server).isNotEmpty, true);
      }
    },
  );

  test(
    'GIVEN certificate usages WHEN get usages THEN get the correct text',
    () async {
      AppLocalizations localizations =
          await AppLocalizations.delegate.load(const Locale('es'));
      const values = CertificateUsageEnum.values;

      void check(
        bool value1,
        bool value2,
        bool value3,
      ) {
        final result = [
          if (value1) values[0],
          if (value2) values[1],
          if (value3) values[2],
        ];

        expect(
          localizations.certificateUsages(result).split(',').length,
          result.length <= 1
              ? 1
              : result.length < 3
                  ? 2
                  : 3,
        );
      }

      check(false, false, false);
      check(false, false, true);
      check(false, true, false);
      check(false, true, true);
      check(true, false, false);
      check(true, false, true);
      check(true, true, false);
      check(true, true, true);
    },
  );
}
