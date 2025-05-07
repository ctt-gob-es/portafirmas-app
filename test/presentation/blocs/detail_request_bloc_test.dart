import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';

import '../instruments/requests_instruments.dart';
import 'detail_request_bloc_test.mocks.dart';

@GenerateMocks([RequestRepositoryContract])
void main() {
  late MockRequestRepositoryContract requestRepositoryContract;
  late DetailRequestBloc detailRequestBloc;
  setUp(() {
    requestRepositoryContract = MockRequestRepositoryContract();
    detailRequestBloc =
        DetailRequestBloc(repositoryContract: requestRepositoryContract);
  });

  test('initial state is correct', () {
    expect(detailRequestBloc.state, DetailRequestState.initial());
  });

  group('Detail Request Bloc Test', () {
    blocTest<DetailRequestBloc, DetailRequestState>(
      'GIVEN a State loading and success WHEN the Result is success then call to the event fetchDataRequest',
      build: () {
        when(requestRepositoryContract.getRequestDetail('S1yTgmnhw7'))
            .thenAnswer(
          (_) async => Result.success(givenDetailRequestEntity),
        );

        return detailRequestBloc;
      },
      act: (DetailRequestBloc bloc) {
        bloc.add(const DetailRequestEvent.fetchDataRequest('S1yTgmnhw7'));
      },
      expect: () => [
        const DetailRequestState(
          screenStatus: ScreenStatus.loading(),
          loadContent: null,
          isFooterActive: true,
        ),
        DetailRequestState(
          screenStatus: const ScreenStatus.success(),
          loadContent: givenDetailRequestEntity,
          isFooterActive: true,
        ),
      ],
    );

    blocTest<DetailRequestBloc, DetailRequestState>(
      'GIVEN a error message WHEN the Result failure',
      build: () {
        when(requestRepositoryContract.getRequestDetail('S1yTgmnhw7'))
            .thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.badRequest()),
        );

        return detailRequestBloc;
      },
      act: (DetailRequestBloc bloc) {
        bloc.add(const DetailRequestEvent.fetchDataRequest('S1yTgmnhw7'));
      },
      expect: () => [
        const DetailRequestState(
          screenStatus: ScreenStatus.loading(),
          loadContent: null,
          isFooterActive: true,
        ),
        const DetailRequestState(
          screenStatus: ScreenStatus.error(RepositoryError.badRequest()),
          loadContent: null,
          isFooterActive: true,
        ),
      ],
    );

    blocTest<DetailRequestBloc, DetailRequestState>(
      'GIVEN a false value WHEN call to footerVisibility event THEN change the value of isFooterActive',
      build: () => detailRequestBloc,
      act: (DetailRequestBloc bloc) => bloc.add(
        const DetailRequestEvent.footerVisibility(),
      ),
      expect: () => [
        const DetailRequestState(
          screenStatus: ScreenStatus.loading(),
          loadContent: null,
          isFooterActive: false,
        ),
      ],
    );
  });
}
