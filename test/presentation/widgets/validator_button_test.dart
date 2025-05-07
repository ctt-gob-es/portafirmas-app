import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/validator_button.dart';

import '../../data/instruments/request_data_instruments.dart';
import '../features/settings/validation_screen/validator_search_screen_test.mocks.dart';
import '../instruments/pump_app.dart';

@GenerateMocks([UsersSearchBloc, ValidationScreenBloc])
void main() {
  late MockUsersSearchBloc searchBloc;
  late MockValidationScreenBloc validationBloc;
  late BuildContext myContext;

  setUp(() {
    searchBloc = MockUsersSearchBloc();
    validationBloc = MockValidationScreenBloc();
  });

  testWidgets(
    'Validator search screen button test',
    (WidgetTester widgetTester) async {
      when(validationBloc.stream).thenAnswer((_) => const Stream.empty());
      when(searchBloc.stream).thenAnswer((_) => const Stream.empty());

      when(validationBloc.state).thenAnswer(
        (_) => ValidationScreenState.initial().copyWith(
          listOfValidatorUsers: givenValidatorUser(),
          screenStatus: const ScreenStatus.success(),
        ),
      );

      when(searchBloc.state).thenAnswer(
        (_) => UsersSearchState.initial().copyWith(
          screenStatus: const ScreenStatus.success(),
          selectedUser: validator,
          isButtonEnabled: true,
          isUserAdded: false,
          numberOfResults: 0,
          suggestedUsers: [],
        ),
      );

      await widgetTester.pumpApp(
        ValidatorButtonWidget(
          state: searchBloc.state,
        ),
        onGetContext: (context) => myContext = context,
        providers: [
          BlocProvider<UsersSearchBloc>.value(value: searchBloc),
          BlocProvider<ValidationScreenBloc>.value(value: validationBloc),
        ],
      );

      var button = find.text(myContext.localizations.add_new_validator_button);
      expect(button, findsOneWidget);
      await widgetTester.ensureVisible(button);
      await widgetTester.tap(button);

      await widgetTester.pumpAndSettle();
    },
  );
}
