import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/features/detail/model/sign_data.dart';

import '../../../instruments/requests_instruments.dart';

void main() {
  test(
    'GIVEN a xmlString WHEN calls SignDataExtension THEN returns expected XML string',
    () => expect(
      givenSignDataFullContent.xmlString,
      '<result><p n=\'PRE\'>${givenSignDataFullContent.preSignContent}</p><p n=\'NEED_PRE\'>${givenSignDataFullContent.needPre}</p><p n=\'ENCODING\'>${givenSignDataFullContent.preSignEncoding}</p><p n=\'BASE\'>${givenSignDataFullContent.signBase}</p><p n=\'NEED_DATA\'>${givenSignDataFullContent.needData}</p><p n=\'TIME\'>${givenSignDataFullContent.time}</p><p n=\'PID\'>${givenSignDataFullContent.pid}</p><p n=\'PK1\'>${givenSignDataFullContent.signResultBase64}</p></result>',
    ),
  );
}
