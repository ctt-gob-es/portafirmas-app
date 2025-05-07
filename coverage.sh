flutter test --coverage
lcov --remove coverage/lcov.info \
'lib/app/di/*' \
'interceptors/*' \
'dio_http_client.dart' \
'lib/face_routes.dart' \
'*.g.dart' \
'*.freezed.dart' \
-o coverage/lcov.info
genhtml coverage/lcov.info --output=coverage
open coverage/index.html