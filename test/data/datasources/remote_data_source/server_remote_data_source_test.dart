import 'package:emm/emm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/server_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/server_remote_data_source.dart';

import 'server_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ServerApiContract>(), MockSpec<Emm>()])
void main() {
  late MockServerApiContract mockApi;
  late MockEmm emm;
  late ServerRemoteDataSource dataSource;

  setUp(() {
    mockApi = MockServerApiContract();
    emm = MockEmm();
    dataSource = ServerRemoteDataSource(mockApi, emm);
  });

  group('ServerRemoteDataSource', () {
    test('should return true when server is valid', () async {
      when(mockApi.isAValidServer(url: 'https://valid.url'))
          .thenAnswer((_) async => true);

      final result = await dataSource.isAValidServer(url: 'https://valid.url');

      expect(result, true);
      verify(mockApi.isAValidServer(url: 'https://valid.url')).called(1);
    });

    test('should return false when server is invalid', () async {
      when(mockApi.isAValidServer(url: 'https://invalid.url'))
          .thenAnswer((_) async => false);

      final result =
          await dataSource.isAValidServer(url: 'https://invalid.url');

      expect(result, false);
      verify(mockApi.isAValidServer(url: 'https://invalid.url')).called(1);
    });
  });
}
