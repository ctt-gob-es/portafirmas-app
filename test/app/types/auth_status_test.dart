import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';

void main() {
  group('UserAuthStatus', () {
    test('Unidentified should be identified as unidentified', () {
      const status = UserAuthStatus.unidentified();

      expect(status.isUnidentified(), true);
      expect(status.isLoggedIn(), false);
      expect(status.isError(), false);
      expect(status.isClaveUrlLoaded(), false);
    });

    test('LoggedIn should be identified as loggedIn', () {
      const status =
          UserAuthStatus.loggedIn(dni: '12345678A', loggedWithClave: true);

      expect(status.isLoggedIn(), true);
      expect(status.isUnidentified(), false);
      expect(status.isError(), false);
      expect(status.isClaveUrlLoaded(), false);
      expect(status.isLoggedInWithClave(), true);
    });

    test('Error should be identified as error', () {
      const status = UserAuthStatus.error(error: ClaveErrorType.expired);

      expect(status.isError(), true);
      expect(status.isLoggedIn(), false);
      expect(status.isUnidentified(), false);
      expect(status.isClaveUrlLoaded(), false);
      expect(status.error, ClaveErrorType.expired);
    });
  });

  group('ClaveErrorType', () {
    test('fromValue should return unauthorized for COD_103', () {
      final errorType = ClaveErrorType.fromValue('COD_103 some error');
      expect(errorType, ClaveErrorType.unauthorized);
    });

    test('fromValue should return expired for COD_104', () {
      final errorType = ClaveErrorType.fromValue('COD_104 some error');
      expect(errorType, ClaveErrorType.expired);
    });

    test('fromValue should return revoked for COD_105', () {
      final errorType = ClaveErrorType.fromValue('COD_105 some error');
      expect(errorType, ClaveErrorType.revoked);
    });

    test('fromValue should return unknown for other values', () {
      final errorType = ClaveErrorType.fromValue('COD_999 some error');
      expect(errorType, ClaveErrorType.unknown);
    });
  });
}
