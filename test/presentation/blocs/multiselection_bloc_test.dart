import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';

import '../../data/instruments/request_data_instruments.dart';

void main() {
  late MultiSelectionRequestBloc multiSelectionRequestBloc;

  setUp(() {
    multiSelectionRequestBloc = MultiSelectionRequestBloc();
  });

  group('Multiselection bloc test', () {
    blocTest(
      'GIVEN multiselection bloc, WHEN I call the event, it returns to initial state',
      build: () => multiSelectionRequestBloc,
      act: (MultiSelectionRequestBloc bloc) {
        bloc.add(const MultiSelectionRequestEvent.initialState());
      },
      expect: () => [
        const MultiSelectionRequestState(
          isButtonEnabled: false,
          isSelected: false,
          selectedRequests: {},
          showCheckbox: false,
        ),
      ],
    );
    blocTest(
      'GIVEN multiselection bloc, WHEN I call the event, the checkbox should appear',
      build: () => multiSelectionRequestBloc,
      act: (MultiSelectionRequestBloc bloc) {
        bloc.add(const MultiSelectionRequestEvent.showCheckbox(true));
      },
      expect: () => [
        const MultiSelectionRequestState(
          isButtonEnabled: false,
          isSelected: false,
          selectedRequests: {},
          showCheckbox: true,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.showCheckbox, true);
      },
    );
    blocTest(
      'GIVEN multiselection bloc, WHEN I call the event, I can select a request in checkbox',
      build: () => multiSelectionRequestBloc,
      act: (MultiSelectionRequestBloc bloc) {
        bloc.add(MultiSelectionRequestEvent.isCheckBoxSelected(
          true,
          givenRequestEntityList()[0],
        ));
      },
      expect: () => [
        MultiSelectionRequestState(
          isButtonEnabled: true,
          isSelected: true,
          selectedRequests: requestSelected,
          showCheckbox: false,
        ),
      ],
    );
    blocTest(
      'GIVEN multiselection bloc, WHEN I call the event, I can unselect a request in checkbox',
      build: () => multiSelectionRequestBloc,
      act: (MultiSelectionRequestBloc bloc) {
        bloc.add(MultiSelectionRequestEvent.isCheckBoxSelected(
          false,
          givenRequestEntityList()[0],
        ));
      },
      expect: () => [
        const MultiSelectionRequestState(
          isSelected: false,
          showCheckbox: false,
          selectedRequests: {},
          isButtonEnabled: false,
        ),
      ],
    );
    blocTest(
      'GIVEN multiselection bloc, WHEN I call the event selectAllRequests, I can select all the request',
      build: () => multiSelectionRequestBloc,
      act: (MultiSelectionRequestBloc bloc) {
        bloc.add(MultiSelectionRequestEvent.selectAllRequests(
          true,
          givenRequestEntityList(),
        ));
      },
      expect: () => [
        MultiSelectionRequestState(
          isSelected: false,
          showCheckbox: false,
          selectedRequests: requestListSelected,
          isButtonEnabled: true,
        ),
      ],
    );
  });
}
