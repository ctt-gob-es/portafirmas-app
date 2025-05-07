import 'dart:typed_data';

import 'package:portafirmas_app/data/models/pre_login_remote_entity.dart';

PreLoginRemoteEntity givenPreLoginRemoteEntity() => const PreLoginRemoteEntity(
      cookie: 'sessionId',
      loginRequest: 'loginRequest',
    );

Uint8List givenUInt8List() => Uint8List.fromList('text'.codeUnits);
