import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/utils/clave_utils.dart';

import '../data/instruments/request_data_instruments.dart';

void main() {
  test(
    'GIVEN a status in String WHEN call to function THEN I get the username',
    () {
      String expectedResult = '1234567A';

      String result = IdentificationClaveUtils.getDni(isLoggedWithClave);

      expect(result, expectedResult);
    },
  );
}
