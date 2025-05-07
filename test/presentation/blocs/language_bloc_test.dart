import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/top_blocs/language_bloc/language_bloc.dart';

void main() {
  late LanguagesBloc languageBloc;

  setUp(() {
    languageBloc = LanguagesBloc();
  });

  blocTest(
    'language bloc test',
    build: () => languageBloc,
    act: (LanguagesBloc bloc) {
      bloc.add(
        const LanguageBlocEvent.changedLanguage(
          Locale.fromSubtags(languageCode: 'es'),
        ),
      );
    },
    expect: () => [
      const LanguageBlocState(
        locale: Locale.fromSubtags(
          languageCode: 'es',
        ),
      ),
    ],
    verify: (bloc) {
      expect(
        bloc.state.isSelected(
          const Locale.fromSubtags(languageCode: 'es'),
        ),
        true,
      );
    },
  );
}
