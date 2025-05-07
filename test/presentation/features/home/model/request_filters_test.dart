import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';

void main() {
  group('RequestFilters', () {
    test('initialForValidators should initialize filters correctly', () {
      final filters = RequestFilters.initialForValidators();

      expect(filters.pendingFilter, RequestFilter.notValidated());
      expect(filters.signedFilter, RequestFilter.initial());
      expect(filters.rejectedFilter, RequestFilter.initial());
      expect(filters.validatedFilter, RequestFilter.validated());
    });
  });
}
