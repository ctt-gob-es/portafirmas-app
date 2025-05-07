import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/request_filters_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';

void main() {
  group('RequestFiltersPetitionRemoteEntity', () {
    test(
      'should correctly create a RequestFiltersPetitionRemoteEntity from RequestFilter',
      () {
        const filter = RequestFilter(
          order: OrderFilter.mostRecent,
          requestType: RequestTypeFilter.all,
          timeInterval: TimeIntervalFilter.lastWeek,
          inputFilter: 'filter',
          app: RequestAppData(id: 'app1', name: 'myApp'),
        );
        const userNif = 'userNif';
        const dniValidatorFilter = 'dniValidatorFilter';

        final result = RequestFiltersPetitionRemoteEntity.fromRequestFilters(
          filter,
          userNif,
          dniValidatorFilter,
        );

        expect(result.orderAscDesc, 'desc');
        expect(result.orderAttribute, 'fmodified');
        expect(result.type, 'view_all');
        expect(result.monthFilter, 'lastWeek');
        expect(result.search, 'filter');
        expect(result.application, 'app1');
        expect(result.userId, 'userNif');
        expect(result.dniValidator, 'dniValidatorFilter');
      },
    );

    test('should handle oldest order correctly', () {
      const filter = RequestFilter(
        order: OrderFilter.oldest,
        requestType: RequestTypeFilter.validated,
        timeInterval: TimeIntervalFilter.lastWeek,
        inputFilter: 'hola',
        app: RequestAppData(id: 'app1', name: 'myApp'),
      );
      const userNif = '12345';
      const dniValidatorFilter = '67890';

      final result = RequestFiltersPetitionRemoteEntity.fromRequestFilters(
        filter,
        userNif,
        dniValidatorFilter,
      );

      expect(result.orderAscDesc, 'asc');
      expect(result.orderAttribute, 'fmodified');
      expect(result.type, 'view_validate');
      expect(result.monthFilter, 'lastWeek');
    });

    test('should handle about to expire order correctly', () {
      const filter = RequestFilter(
        order: OrderFilter.aboutToExpire,
        requestType: RequestTypeFilter.sign,
        timeInterval: TimeIntervalFilter.last24h,
        inputFilter: 'hola',
        app: RequestAppData(id: 'app1', name: 'myApp'),
      );
      const userNif = '12345';
      const dniValidatorFilter = '67890';

      final result = RequestFiltersPetitionRemoteEntity.fromRequestFilters(
        filter,
        userNif,
        dniValidatorFilter,
      );

      expect(result.orderAscDesc, 'asc');
      expect(result.orderAttribute, 'fexpiration');
      expect(result.type, 'view_sign');
      expect(result.monthFilter, 'last24Hours');
    });

    test('should handle different request types correctly', () {
      const filter = RequestFilter(
        order: OrderFilter.mostRecent,
        requestType: RequestTypeFilter.approval,
        timeInterval: TimeIntervalFilter.all,
        inputFilter: 'hola',
        app: RequestAppData(id: 'app1', name: 'myApp'),
      );
      const userNif = '12345';
      const dniValidatorFilter = '67890';

      final result = RequestFiltersPetitionRemoteEntity.fromRequestFilters(
        filter,
        userNif,
        dniValidatorFilter,
      );

      expect(result.type, 'view_pass');
    });

    test('should handle all time intervals correctly', () {
      const filter = RequestFilter(
        order: OrderFilter.oldest,
        requestType: RequestTypeFilter.notValidated,
        timeInterval: TimeIntervalFilter.lastMonth,
        inputFilter: 'hola',
        app: RequestAppData(id: 'app1', name: 'myApp'),
      );
      const userNif = '12345';
      const dniValidatorFilter = '67890';

      final result = RequestFiltersPetitionRemoteEntity.fromRequestFilters(
        filter,
        userNif,
        dniValidatorFilter,
      );

      expect(result.monthFilter, 'lastMonth');
    });
  });
}
