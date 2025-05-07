import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/auth_observations_remote_entity.dart';
import 'package:portafirmas_app/domain/models/auth_observations_entity.dart';

void main() {
  group('AuthObservationsRemoteEntityExtension', () {
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
