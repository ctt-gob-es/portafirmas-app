import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/models/push_petition_remote_entity.dart';

void main() {
  group('PushPetitionRemoteEntity', () {
    test('should correctly instantiate PushPetitionRemoteEntity', () {
      const entity = PushPetitionRemoteEntity(
        platform: 1,
        pushToken: 'samplePushToken',
        uuid: 'sampleUuid',
        nif: 'sampleNif',
      );

      expect(entity.platform, 1);
      expect(entity.pushToken, 'samplePushToken');
      expect(entity.uuid, 'sampleUuid');
      expect(entity.nif, 'sampleNif');
    });

    test('should correctly generate xmlString', () {
      const entity = PushPetitionRemoteEntity(
        platform: 1,
        pushToken: 'samplePushToken',
        uuid: 'sampleUuid',
        nif: 'sampleNif',
      );

      expect(
        entity.xmlString,
        '<rqtreg plt="1" tkn="samplePushToken" dvc="sampleUuid"><cert>sampleNif</cert></rqtreg>',
      );
    });
  });
}
