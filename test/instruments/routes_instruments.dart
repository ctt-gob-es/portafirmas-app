class InstrumentsRoutePath {
  static String splash = '/';
  static String onBoarding = '/onBoarding';
  // Home
  static String home = '/home';
  static String requestsScreen = '$home/requestsScreen';
  static String requestsSignWithClave = '$requestsScreen/signWithClaveScreen';

  // Initial access
  static const String initialAccess = '/accessScreen';

  // Servers
  static String selectServer = '$initialAccess/selectFirstTimeServer';
  static String serverEditionPath = '/edit';
  static String changeServer = '$initialAccess/servers';
  static String changeServerInCertServer = '$serverCertScreen/servers';

  // Authentication
  static String authentication = '$initialAccess/authentication';

  // Certificates
  static String explainAddCert = '$authentication/explainAddCert';
  static String addCertificateSuccess = '$explainAddCert/certAddSuccess';
  static String addCertificateError = '$explainAddCert/certAddError';

  static String serverCertScreen = '$authentication/serverCertScreen';
  static String certificatesListIOS = '$serverCertScreen/certificates';
  static String certificateWarningAndroid =
      '$serverCertScreen/certificateWarning';

  // Detail
  static String detailRequest = '$requestsScreen/detailRequestScreen';
  static String detailSignWithClave = '$detailRequest/signWithClaveScreen';
  static String addressee = '$detailRequest/addresseeScreen';
  static String annexes = '$detailRequest/annexesScreen';
  static String signDetail = '$detailRequest/signDetailScreen';
  static String informSignDetail = '$detailRequest/informSignDetailScreen';

  // Settings
  static String settingsScreen = '$requestsScreen/settingsScreen';
  static String profileScreen = '$settingsScreen/profileScreen';
  static String validationScreen = '$settingsScreen/validationScreen';
  static String validationSearchScreen =
      '$validationScreen/validationSearchScreen';
  static String authorizationScreen = '$settingsScreen/authorizationScreen';
  static String addAuthorizedScreen =
      '$authorizationScreen/addAuthorizedScreen';
  static String authorizationDetailsScreen =
      '$authorizationScreen/authorizationDetailsScreen';
  static String languageScreen = '$settingsScreen/languageScreen';
  static String filtersScreen = '$requestsScreen/filtersScreen';
  static String supportScreen = '$settingsScreen/supportScreen';
}
