import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/auth_observations_remote_entity.dart';
import 'package:portafirmas_app/domain/models/auth_observations_entity.dart';

void main() {
  group('AuthObservationsRemoteEntity', () {
    test(
      'fromJson should correctly convert JSON to AuthObservationsRemoteEntity',
      () {
        final json = {
          '__cdata': 'This is a test observation',
        };

        final entity = AuthObservationsRemoteEntity.fromJson(json);

        expect(entity.observations, 'This is a test observation');
      },
    );

    test(
      'toJson should correctly convert AuthObservationsRemoteEntity to JSON',
      () {
        const entity = AuthObservationsRemoteEntity(
          observations: 'This is a test observation',
        );

        final json = entity.toJson();

        expect(json['__cdata'], 'This is a test observation');
      },
    );

    test(
      'should convert AuthObservationsRemoteEntity to AuthObservationsEntity',
      () {
        const authObservationsRemoteEntity = AuthObservationsRemoteEntity(
          observations: 'Some remote observation',
        );

        final authObservationsEntity =
            authObservationsRemoteEntity.toObservationsEntity();

        expect(authObservationsEntity.observations, 'Some remote observation');
      },
    );
  });
}
