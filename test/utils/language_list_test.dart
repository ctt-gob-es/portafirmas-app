import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/features/settings/utils/language_list.dart';

void main() {
  group('Language_list test', () {
    test(
      'GIVEN a language title, WHEN it changes THEN returns correct value',
      () {
        expect(const Language.es().title(), 'Español');
        expect(const Language.en().title(), 'English');
        expect(const Language.ca().title(), 'Catalá');
        expect(const Language.ga().title(), 'Galego');
        expect(const Language.eu().title(), 'Euskera');
      },
    );

    test(
      'GIVEN a language code, WHEN it changes THEN returns correct value',
      () {
        expect(const Language.es().languageCode(), 'es');
        expect(const Language.en().languageCode(), 'en');
        expect(const Language.ca().languageCode(), 'ca');
        expect(const Language.ga().languageCode(), 'gl');
        expect(const Language.eu().languageCode(), 'eu');
      },
    );

    test(
      'GIVEN a fromLocale title, WHEN it changes THEN returns correct value',
      () {
        expect(LanguageExtension.fromLocale('es'), equals(const Language.es()));
        expect(LanguageExtension.fromLocale('en'), equals(const Language.en()));
        expect(LanguageExtension.fromLocale('ca'), equals(const Language.ca()));
        expect(LanguageExtension.fromLocale('gl'), equals(const Language.ga()));
        expect(LanguageExtension.fromLocale('eu'), equals(const Language.eu()));
      },
    );

    test(
      'GIVEN a languageExtension values, THEN it loads all available languages',
      () {
        final languages = LanguageExtension.values();
        expect(languages, hasLength(5));
        expect(
          languages,
          containsAll([
            const Language.es(),
            const Language.en(),
            const Language.ca(),
            const Language.ga(),
            const Language.eu(),
          ]),
        );
        expect(languages, everyElement(isNotNull));
      },
    );
  });
}
