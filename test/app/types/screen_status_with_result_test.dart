import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/types/screen_status_with_result.dart';

void main() {
  group('ScreenStatusWithResult', () {
    test('isLoading returns true for loading status', () {
      const loadingStatus = ScreenStatusWithResult<String>.loading();
      
      expect(loadingStatus.isLoading(), isTrue);
    });

    test('isLoading returns false for non-loading status', () {
      const successStatus = ScreenStatusWithResult<String>.success('Data');
      const errorStatus =
          ScreenStatusWithResult<String>.error('An error occurred');
      const initialStatus = ScreenStatusWithResult<String>.initial();
      expect(successStatus.isLoading(), isFalse);
      expect(errorStatus.isLoading(), isFalse);
      expect(initialStatus.isLoading(), isFalse);
    });

    test('isError returns true for error status', () {
      const errorStatus =
          ScreenStatusWithResult<String>.error('An error occurred');
      expect(errorStatus.isError(), isTrue);
    });

    test('isError returns false for non-error status', () {
      const successStatus = ScreenStatusWithResult<String>.success('Data');
      const loadingStatus = ScreenStatusWithResult<String>.loading();
      const initialStatus = ScreenStatusWithResult<String>.initial();
      expect(successStatus.isError(), isFalse);
      expect(loadingStatus.isError(), isFalse);
      expect(initialStatus.isError(), isFalse);
    });

    test('isSuccess returns true for success status', () {
      const successStatus = ScreenStatusWithResult<String>.success('Data');
      expect(successStatus.isSuccess(), isTrue);
    });

    test('isSuccess returns false for non-success status', () {
      const errorStatus =
          ScreenStatusWithResult<String>.error('An error occurred');
      const loadingStatus = ScreenStatusWithResult<String>.loading();
      const initialStatus = ScreenStatusWithResult<String>.initial();
      expect(errorStatus.isSuccess(), isFalse);
      expect(loadingStatus.isSuccess(), isFalse);
      expect(initialStatus.isSuccess(), isFalse);
    });
  });
}
