import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/add_authorization_remote_entity.dart';

void main() {
  group('AddAuthorizationRemoteEntity', () {
    test(
      'fromJson should correctly convert JSON to AddAuthorizationRemoteEntity',
      () {
        final json = {
          'result': {'\$t': 'Success'},
        };

        final entity = AddAuthorizationRemoteEntity.fromJson(json);

        expect(entity.result.value, 'Success');
      },
    );
  });
}
