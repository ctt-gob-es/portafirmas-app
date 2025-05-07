import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';

import '../../instruments/widgets_instruments.dart';
import 'app_filter_bloc_test.mocks.dart';

@GenerateMocks([RequestRepositoryContract])
void main() {
  late AppFilterBloc appFilterBloc;
  late MockRequestRepositoryContract requestRepositoryContract;

  setUp(() {
    requestRepositoryContract = MockRequestRepositoryContract();
    appFilterBloc =
        AppFilterBloc(repositoryContract: requestRepositoryContract);
  });

  group('app filter bloc test', () {
    blocTest(
      'GIVEN app filter bloc, WHEN getRequestApp event is called, THEN appList will be loaded in the state',
      build: () => appFilterBloc,
      act: (AppFilterBloc bloc) {
        when(requestRepositoryContract.getUserRequestApps())
            .thenAnswer((_) async {
          return Result.success(WidgetsInstruments.getRequestAppDataList());
        });

        bloc.add(const AppFilterEvent.getAppList());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const AppFilterState(
          appList: null,
          screenStatus: ScreenStatus.loading(),
        ),
        AppFilterState(
          appList: WidgetsInstruments.getRequestAppDataList(),
          screenStatus: const ScreenStatus.success(),
        ),
      ],
    );
  });
}
