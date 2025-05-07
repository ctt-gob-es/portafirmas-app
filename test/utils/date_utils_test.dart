import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/utils/server_date_utils.dart';

void main() {
  test(
    'GIVEN a date in String WHEN call to parse THEN I get parsed date',
    () {
      String dateToParse = '13/07/2023 13:25:26';
      DateTime expectedResult = DateTime(2023, 7, 13, 13, 25, 26);

      DateTime result = ServerDateUtils.parseFromServer(dateToParse);

      expect(result.year, expectedResult.year);
      expect(result.month, expectedResult.month);
      expect(result.day, expectedResult.day);
      expect(result.hour, expectedResult.hour);
      expect(result.minute, expectedResult.minute);
      expect(result.second, expectedResult.second);
    },
  );
}
