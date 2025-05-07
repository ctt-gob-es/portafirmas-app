import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';

import '../../instruments/routes_instruments.dart';

void main() {
  test(
    'GIVEN a splash Route WHEN call to RoutePath.splash THEN return correct route',
    () => expect(RoutePath.splash, InstrumentsRoutePath.splash),
  );
  test(
    'GIVEN a onBoarding Route WHEN call to RoutePath.onBoarding THEN return correct route',
    () => expect(RoutePath.onBoarding, InstrumentsRoutePath.onBoarding),
  );
  test(
    'GIVEN a home Route WHEN call to RoutePath.home THEN return correct route',
    () => expect(RoutePath.home, InstrumentsRoutePath.home),
  );
  test(
    'GIVEN a requestsScreen Route WHEN call to RoutePath.requestsScreen THEN return correct route',
    () => expect(RoutePath.requestsScreen, InstrumentsRoutePath.requestsScreen),
  );
  test(
    'GIVEN a requestsSignWithClave Route WHEN call to RoutePath.requestsSignWithClave THEN return correct route',
    () => expect(
      RoutePath.requestsSignWithClave,
      InstrumentsRoutePath.requestsSignWithClave,
    ),
  );
  test(
    'GIVEN a accessFirstTime Route WHEN call to RoutePath.initialAccess THEN return correct route',
    () => expect(RoutePath.accessScreen, InstrumentsRoutePath.initialAccess),
  );
  test(
    'GIVEN a selectServer Route WHEN call to RoutePath.selectServer THEN return correct route',
    () => expect(RoutePath.selectServer, InstrumentsRoutePath.selectServer),
  );
  test(
    'GIVEN a serverEditionPath Route WHEN call to RoutePath.serverEditionPath THEN return correct route',
    () => expect(
      RoutePath.serverEditionPath,
      InstrumentsRoutePath.serverEditionPath,
    ),
  );
  test(
    'GIVEN a changeServer Route WHEN call to RoutePath.changeServer THEN return correct route',
    () => expect(
      RoutePath.changeServer,
      InstrumentsRoutePath.changeServer,
    ),
  );

  test(
    'GIVEN a changeServerInCertServer Route WHEN call to RoutePath.changeServerInCertServer THEN return correct route',
    () => expect(
      RoutePath.changeServerInCertServer,
      InstrumentsRoutePath.changeServerInCertServer,
    ),
  );
  test(
    'GIVEN a authentication Route WHEN call to RoutePath.authentication THEN return correct route',
    () => expect(
      RoutePath.authentication,
      InstrumentsRoutePath.authentication,
    ),
  );
  test(
    'GIVEN a explainAddCert Route WHEN call to RoutePath.explainAddCert THEN return correct route',
    () => expect(
      RoutePath.explainAddCert,
      InstrumentsRoutePath.explainAddCert,
    ),
  );
  test(
    'GIVEN a addCertificateSuccess Route WHEN call to RoutePath.addCertificateSuccess THEN return correct route',
    () => expect(
      RoutePath.addFirstCertificateSuccess,
      InstrumentsRoutePath.addCertificateSuccess,
    ),
  );
  test(
    'GIVEN a addCertificateError Route WHEN call to RoutePath.addCertificateError THEN return correct route',
    () => expect(
      RoutePath.addFirstCertificateError,
      InstrumentsRoutePath.addCertificateError,
    ),
  );
  test(
    'GIVEN a serverCertScreen Route WHEN call to RoutePath.serverCertScreen THEN return correct route',
    () => expect(
      RoutePath.serverCertScreen,
      InstrumentsRoutePath.serverCertScreen,
    ),
  );
  test(
    'GIVEN a serverCertScreen Route WHEN call to RoutePath.serverCertScreen THEN return correct route',
    () => expect(
      RoutePath.serverCertScreen,
      InstrumentsRoutePath.serverCertScreen,
    ),
  );
  test(
    'GIVEN a certificatesListIOS Route WHEN call to RoutePath.certificatesListIOS THEN return correct route',
    () => expect(
      RoutePath.certificatesListIOS,
      InstrumentsRoutePath.certificatesListIOS,
    ),
  );
  test(
    'GIVEN a certificateWarningAndroid Route WHEN call to RoutePath.certificateWarningAndroid THEN return correct route',
    () => expect(
      RoutePath.certificateWarningAndroid,
      InstrumentsRoutePath.certificateWarningAndroid,
    ),
  );
  test(
    'GIVEN a detailRequest Route WHEN call to RoutePath.detailRequest THEN return correct route',
    () => expect(
      RoutePath.detailRequest,
      InstrumentsRoutePath.detailRequest,
    ),
  );
  test(
    'GIVEN a addressee Route WHEN call to RoutePath.addressee THEN return correct route',
    () => expect(
      RoutePath.addressee,
      InstrumentsRoutePath.addressee,
    ),
  );
  test(
    'GIVEN a annexes Route WHEN call to RoutePath.annexes THEN return correct route',
    () => expect(
      RoutePath.annexes,
      InstrumentsRoutePath.annexes,
    ),
  );
  test(
    'GIVEN a signDetail Route WHEN call to RoutePath.signDetail THEN return correct route',
    () => expect(
      RoutePath.signDetail,
      InstrumentsRoutePath.signDetail,
    ),
  );
  test(
    'GIVEN a informSignDetail Route WHEN call to RoutePath.informSignDetail THEN return correct route',
    () => expect(
      RoutePath.informSignDetail,
      InstrumentsRoutePath.informSignDetail,
    ),
  );
  test(
    'GIVEN a settingsScreen Route WHEN call to RoutePath.settingsScreen THEN return correct route',
    () => expect(
      RoutePath.settingsScreen,
      InstrumentsRoutePath.settingsScreen,
    ),
  );
  test(
    'GIVEN a profileScreen Route WHEN call to RoutePath.profileScreen THEN return correct route',
    () => expect(
      RoutePath.profileScreen,
      InstrumentsRoutePath.profileScreen,
    ),
  );
  test(
    'GIVEN a validationScreen Route WHEN call to RoutePath.validationScreen THEN return correct route',
    () => expect(
      RoutePath.validationScreen,
      InstrumentsRoutePath.validationScreen,
    ),
  );
  test(
    'GIVEN a validationSearchScreen Route WHEN call to RoutePath.validationSearchScreen THEN return correct route',
    () => expect(
      RoutePath.validationSearchScreen,
      InstrumentsRoutePath.validationSearchScreen,
    ),
  );
  test(
    'GIVEN a authorizationScreen Route WHEN call to RoutePath.authorizationScreen THEN return correct route',
    () => expect(
      RoutePath.authorizationScreen,
      InstrumentsRoutePath.authorizationScreen,
    ),
  );
  test(
    'GIVEN a addAuthorizedScreen Route WHEN call to RoutePath.addAuthorizedScreen THEN return correct route',
    () => expect(
      RoutePath.addAuthorizedScreen,
      InstrumentsRoutePath.addAuthorizedScreen,
    ),
  );
  test(
    'GIVEN a authorizationDetailsScreen Route WHEN call to RoutePath.authorizationDetailsScreen THEN return correct route',
    () => expect(
      RoutePath.authorizationDetailsScreen,
      InstrumentsRoutePath.authorizationDetailsScreen,
    ),
  );
  test(
    'GIVEN a languageScreen Route WHEN call to RoutePath.languageScreen THEN return correct route',
    () => expect(
      RoutePath.languageScreen,
      InstrumentsRoutePath.languageScreen,
    ),
  );
  test(
    'GIVEN a filtersScreen Route WHEN call to RoutePath.filtersScreen THEN return correct route',
    () => expect(
      RoutePath.filtersScreen,
      InstrumentsRoutePath.filtersScreen,
    ),
  );
  test(
    'GIVEN a supportScreen Route WHEN call to RoutePath.supportScreen THEN return correct route',
    () => expect(
      RoutePath.supportScreen,
      InstrumentsRoutePath.supportScreen,
    ),
  );
}
