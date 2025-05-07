import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/accept_authorization_remote_entity.dart';

void main() {
  group('AcceptAuthRemoteEntity', () {
    test(
      'fromJson should correctly convert JSON to AcceptAuthRemoteEntity',
      () {
        final json = {
          'result': {'\$t': 'Accepted'},
        };

        final entity = AcceptAuthRemoteEntity.fromJson(json);

        expect(entity.result.value, 'Accepted');
      },
    );
  });
}
