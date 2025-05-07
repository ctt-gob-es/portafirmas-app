import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/post_sign_req_entity.dart';

void main() {
  group('PostSignReqEntity.fromJson', () {
    test('should parse JSON correctly', () {
      final json = {
        'requestId': '12345',
        'status': true,
      };

      final postSignReqEntity = PostSignReqEntity.fromJson(json);

      expect(postSignReqEntity.requestId, '12345');
      expect(postSignReqEntity.status, true);
    });
  });
}
