import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/auth_api.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';

import '../../../instruments/auth_data_instruments.dart';
import 'auth_api_test.mocks.dart';

@GenerateMocks([ServersLocalDataSourceContract, AuthApi])
void main() {
  late MockAuthApi api;

  setUp(() {
    api = MockAuthApi();
  });
  test(
    'preLogin should return PreLoginRemoteEntity on success',
    () async {
      when(api.preLogin()).thenAnswer(
        (_) async => givenPreLoginRemoteEntity(),
      );
      final res = await api.preLogin();

      verify(api.preLogin()).called(1);
      assert(res == givenPreLoginRemoteEntity());
    },
  );
}
