import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/portafirmas_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/data/repositories/repository_portafirmas.dart';

import 'repository_portafirmas_test.mocks.dart';

@GenerateMocks([PortafirmasLocalDataSourceContract])
void main() {
  late MockPortafirmasLocalDataSourceContract portafirmasLocalContract;
  late RepositoryPortafirmas repoPortafirmas;
  setUp(() {
    portafirmasLocalContract = MockPortafirmasLocalDataSourceContract();
    repoPortafirmas = RepositoryPortafirmas(portafirmasLocalContract);
  });

  test(
    'GIVEN a RepositoryPortafirmas WHEN call to getWelcomeTourIsFinish THEN return data',
    () async {
      when(portafirmasLocalContract.getWelcomeTourIsFinish())
          .thenAnswer((_) async => true);
      final res = await repoPortafirmas.getWelcomeTourIsFinish();

      assert(
        res.when(
          failure: (e) => false,
          success: (d) => d,
        ),
      );
    },
  );
  test(
    'GIVEN a RepositoryPortafirmas WHEN call to getWelcomeTourIsFinish THEN return failure',
    () async {
      final res = await repoPortafirmas.getWelcomeTourIsFinish();

      assert(
        res.when(
          failure: (e) => true,
          success: (d) => false,
        ),
      );
    },
  );
  test(
    'GIVEN a RepositoryPortafirmas WHEN call to setWelcomeTourFinish THEN return success',
    () async {
      when(portafirmasLocalContract.setWelcomeTourFinish())
          .thenAnswer((_) async => true);
      final res = await repoPortafirmas.setWelcomeTourFinish();

      assert(
        res.when(
          failure: (e) => false,
          success: (d) => true,
        ),
      );
    },
  );
  test(
    'GIVEN a RepositoryPortafirmas WHEN call to setWelcomeTourFinish THEN return failure',
    () async {
      when(portafirmasLocalContract.setWelcomeTourFinish()).thenThrow(
        (_) async => const Result.failure(
          error: RepositoryError.serverError(),
        ),
      );
      final res = await repoPortafirmas.setWelcomeTourFinish();
      verify(portafirmasLocalContract.setWelcomeTourFinish()).called(1);

      assert(
        res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (d) => false,
        ),
      );
    },
  );
}
